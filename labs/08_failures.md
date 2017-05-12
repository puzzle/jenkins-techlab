Lab 8: Failures and Notifications
=================================

In this lab we look into how to deal with failures in Jenkins pipelines. A failure is
any kind of error condition that results in an unsuccessful build, e.g.:
* Syntax error in source code
* Error in build script or configuration
* Error in pipeline
* Disk full
* Test failure

Usually a build is aborted when a failure occurs, with the exception of test failures.  
In declarative pipelines error handling is separated from the actual build logic,
on the other hand failure handling can become quite disruptive in scripted pipelines.

Lab 8.1: Failures (Declarative Syntax)
--------------------------------------

```groovy
pipeline {
    agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Requires the "Timestamper Plugin"
    }
    triggers {
        pollSCM('H/5 * * * *')
        cron('@midnight')
    }
    tools {
        jdk 'jdk8'
        maven 'maven35'
    }
    stages {
        stage('Build') {
            steps {
                git url: "https://github.com/LableOrg/java-maven-junit-helloworld"
                sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false'
                archiveArtifacts 'target/*.?ar'
            }
            post {
                always {
                    junit 'target/**/*.xml'  // Requires JUnit plugin
                }
            }
        }
    }
    post {
        success {
            rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/success.png', message: "Build success - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true
        }
        unstable {
            rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/unstable.png', message: "Build unstable - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true 
        }
        failure {
            rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/failure.png', message: "Build failure - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true 
        }
    }
}
```

It's good practice to use the ``always`` directive to ensure the capture test results even when uncatched exceptions
are thrown during test runs. There's also a ``changed`` directive whose steps are executed whenever the build status changes,
e.g. from **unstable** to **success**.
Obviously we'll want eliminate the similar code in the global ``post`` directive. We'll get to that
when we'll visit shared libraries.
The ``rawMesssage`` attribute of ``rocketSend`` tells Rocket.Chat not to add content
on its own like link previews.

Lab 8.2: Failures (Scripted Syntax)
-----------------------------------

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5')),
    pipelineTriggers([
        pollSCM('H/5 * * * *'),
        cron('@midnight')
    ])
])

try {
    timestamps() {
        timeout(time: 10, unit: 'MINUTES') {
            node(env.JOB_NAME.split('/')[0]) {
                stage('Build') {
                    try {
                        withEnv(["JAVA_HOME=${tool 'jdk8'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                            git url: "https://github.com/LableOrg/java-maven-junit-helloworld"
                            sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false'
                            archiveArtifacts 'target/*.?ar'
                        }
                    } finally {
                        junit 'target/**/*.xml'  // Requires JUnit plugin
                    }
                }
            }
            
        }
    }
} catch (e) {
    node {
        rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/failure.png', message: "Build failure - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true 
    }
    throw e
} finally {
    node {
        if (currentBuild.result == 'UNSTABLE') {
             rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/unstable.png', message: "Build unstable - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true 
        } else if (currentBuild.result == null) { // null means success
            rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/success.png', message: "Build success - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true
        }
    }
}
```

It's again good practice to ensure capture of test results in any case using a ``finally` statement.
The ``junit`` and ``rocketSend`` steps need a workspace and must be contained in a ``node`` step.
