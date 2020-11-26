Lab 10: Failures and Notifications
==================================

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


Lab 10.1: Local Rocketchat Setup
------------------

If you use the Local Docker Setup for the Techlab, you need to start a local RocketChat instance and configure the Rocket Chat Notification plugin.

1. Start the local RocketChat with docker-compose. Depending on your docker installation you need to run whis command with `sudo`:
`docker-compose -f local_env/rocketchat-compose.yml up -d`

2. Login to RocketChat at http://localhost:3000 with:
    ```
    user: admin
    password: admin
    ```
3. Open the Jenkins web interface and press `Manage Jenkins` ➡ `Configure System` and scroll down to `Global RocketChat Notifier Settings`
4.  Set settings to to 
    ```
    Rocket Server URL: http://rocketchat:3000
    Login Username: admin
    Login password: admin
    Channel: GENERAL
    ```
5. Click on `Test Connection` if successful, save configuration.



Lab 10.2: Failures
------------------

Declarative pipelines provide the ``post`` section and directives like ``success`` and ``failure``
to deal with failures. Create a new branch named ``lab-10.1`` from branch ``lab-9.1`` (the one
we merged the source into) and change the content of the ``Jenkinsfile`` to:

```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Requires the "Timestamper Plugin"
    }
    tools {
        jdk 'jdk11'
        maven 'maven35'
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false -DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true"'
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
            rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/success.png',  message: "Build success - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true
        }
        unstable {
            rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/unstable.png',  message: "Build unstable - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true
        }
        failure {
            rocketSend avatar: 'https://chat.puzzle.ch/emoji-custom/failure.png',  message: "Build failure - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)", rawMessage: true
        }
    }
}
```

It's good practice to use the ``always`` directive to ensure the capture test results even when uncatched exceptions
are thrown during test runs. There's also a ``changed`` directive whose steps are executed whenever the build status changes,
e.g. from **unstable** to **success**.
Obviously we'll want eliminate the similar code in the global ``post`` directive. We'll get to that when we'll visit shared libraries.
The ``rawMesssage`` attribute of ``rocketSend`` tells Rocket.Chat not to add content on its own like link previews.

**Note:** Check the message of your build in the Rocket.Chat channel.

Lab 10.3: Mail notification
---------------------------

Add mail notification to one of the labs. See <https://jenkins.io/doc/pipeline/steps/> for a list of available steps or use the snippet generator.

Verify your scripts with the [solution](solutions/10_3_failures_solution.md).

Lab 10.4: Break the build
---------------------------

Do a change in branch ``lab-10.1`` or ``lab-10.2`` such that the message in the chat will be: "Build unstable".

**Note:** To change the build result in Jenkins from failed (red) to unstable (yellow), you have to extend the maven command by: ``-Dmaven.test.failure.ignore=true``.
```groovy
sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false -Dmaven.test.failure.ignore=true'
```

---

**End of Lab 10**

<p width="100px" align="right"><a href="11_shared_libs.md">Shared Libraries →</a></p>

[← back to overview](../README.md)
