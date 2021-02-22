---
title: "10. Failures and Notifications"
weight: 10
sectionnumber: 10
---

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


## Task {{% param sectionnumber %}}.1: Local Rocket.Chat Setup

The local Rocket.Chat instance has been started by the docker-compose setup. You need now to configure the Rocket.Chat Notification plugin.

1. Login to Rocket.Chat at <http://localhost:3000> with:

    ```
    user: admin
    password: admin
    ```

1. Open the Jenkins web interface
1. Go to `Dashboard` ➡ `Manage Jenkins` ➡ [Configure System](http://localhost:8080/configure)
1. Scroll down to `Global RocketChat Notifier Settings`
1. Set settings to to
   * Rocket Server URL: `http://rocketchat:3000`
   * Login Username: `admin`
   * Login password: `admin`
   * Channel: `GENERAL`
1. Click on `Test Connection` if successful, save configuration
1. Check Rock.Chat general channel for the test message: <http://localhost:3000/channel/general>


## Task {{% param sectionnumber %}}.2: Failures

Declarative pipelines provide the ``post`` section and directives like ``success`` and ``failure`` to deal with failures.

Create a new branch named ``lab-10.1`` from branch ``lab-9.1`` (the one we merged the source into) and change the content of the ``Jenkinsfile`` to:

<!--
```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
```
-->

```
{{< highlight groovy "hl_lines=19-23 26-45" >}}
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
    }
    tools {
        jdk 'jdk11'
        maven 'maven36'
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
            rocketSend
                avatar: 'https://chat.puzzle.ch/emoji-custom/success.png',
                message: "Build success - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)",
                rawMessage: true
        }
        unstable {
            rocketSend
                avatar: 'https://chat.puzzle.ch/emoji-custom/unstable.png',
                message: "Build unstable - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)",
                rawMessage: true
        }
        failure {
            rocketSend
                avatar: 'https://chat.puzzle.ch/emoji-custom/failure.png',
                message: "Build failure - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)",
                rawMessage: true
        }
    }
}
{{< / highlight >}}
```

It's good practice to use the ``always`` directive to ensure the capture test results even when un-catched exceptions are thrown during test runs.
There's also a ``changed`` directive whose steps are executed whenever the build status changes, e.g. from **unstable** to **success**.
Obviously we'll want eliminate the similar code in the global ``post`` directive. We'll get to that when we'll visit shared libraries.
The ``rawMesssage`` attribute of ``rocketSend`` tells Rocket.Chat not to add content on its own like link previews.


### Check message

Go to the [multibranch pipeline](http://localhost:8080/job/techlab/) of your Jenkins and see, if the pipeline for the new branch is created.

When the job `lab-10.1` is missing, you can click on `Scan Multibranch Pipeline Now` to start the discovery of new branches.

Check the build log (Console Output) of the first run of this pipeline. There should be a log entry for the message being sent to Rocke.Chat.

Find the `Build success` message in the general Rock.Chat channel: <http://localhost:3000/channel/general>

<!--
## Task {{% param sectionnumber %}}.3: Mail notification

If you use the local Jenkins environment, you can skip this step and go ahead to Lab 10.4!

Add mail notification to the previous lab. See <https://jenkins.io/doc/pipeline/steps/> for a list of available steps or use the snippet generator.

Verify your scripts with the [solution](./10_3_failures_solution/).
-->


## Task {{% param sectionnumber %}}.3: Break the build

Do a change in branch ``lab-10.1`` such that the message in the chat will be: "Build unstable".

**Note:** To change the build result in Jenkins from failed (red) to unstable (yellow), you have to extend the maven command by: ``-Dmaven.test.failure.ignore=true``.

```groovy
sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false -Dmaven.test.failure.ignore=true'
```
