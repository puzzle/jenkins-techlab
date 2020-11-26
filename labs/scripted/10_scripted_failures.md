Lab 10.2: Failures (Scripted Syntax)
-----------------------------------
Create a new branch named ``lab-10.2`` from branch ``lab-9.2`` and change the content of the ``Jenkinsfile`` to:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5'))
])

try {
    timestamps() {
        timeout(time: 10, unit: 'MINUTES') {
            node { // with hosted env use node(env.JOB_NAME.split('/')[0])
                stage('Build') {
                    try {
                        withEnv(["JAVA_HOME=${tool 'jdk11'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                            checkout scm
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
        rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/failure.png', channel: 'jenkins-techlab', message: "Build failure - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true
    }
    throw e
} finally {
    node {
        if (currentBuild.result == 'UNSTABLE') {
             rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/unstable.png', channel: 'jenkins-techlab', message: "Build unstable - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true
        } else if (currentBuild.result == null) { // null means success
            rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/success.png', channel: 'jenkins-techlab', message: "Build success - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true
        }
    }
}
```

It's again good practice to ensure capture of test results in any case using a ``finally`` statement.

The ``junit`` and ``rocketSend`` steps need a workspace and must be contained in a ``node`` step.

**Note:** Check the message of your build in the Rocket.Chat channel.
