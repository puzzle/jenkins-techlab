---
title: "11. Shared Libraries"
weight: 11
sectionnumber: 11
---

In the last lab we had some duplicated code implementing notification through Rocket.Chat.
Besides being duplicated the code was also independent of our project, so we want to
move it out of our project in such a way that it can be reused in multiple
projects. This is where pipeline shared libraries come in.


## Task {{% param sectionnumber %}}.1: Create Folder-Level Shared Library

One possibility to implement reusable code is to provide custom steps through a shared library.
The following code provides a custom step named ``notifyPuzzleChat``. Before we can use
the shared library is has to be registered with Jenkins:

1. Create a new GitHub repository with a suitable name, e.g. ``jenkins-techlab-exercise-library``.
1. Create a file named ``vars/notifyPuzzleChat.groovy`` with the following content in the ``master`` branch.

    ```groovy
    def call(String channel) {
        String result = currentBuild.result?.toLowerCase() ?: 'success'
        node {
            rocketSend(
                channel: channel,
                avatar: "https://chat.puzzle.ch/emoji-custom/${result}.png",
                message: "Build ${result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)",
                rawMessage: true)
        }
    }
    ```

1. Go to your [multibranch job folder](http://localhost:8080/job/techlab/)
1. Press **configure**.
1. **Add** a new pipeline library
1. Set the "Name" to ``jenkins-techlab-exercise-library`` and "Default version" to ``master``.
1. Uncheck `Include @Library changes in job recent changes`
   * This prevents triggering of the job by changes in the library.
1. Select the "Retrieval method" "Modern SCM"
1. Select "Git" "Source Code Management"
1. Set "Project Repository" to the URL of your new GitHub repository (use the https URL for anonymous access)
1. At the bottom of the page click `Save`

To make the step useful for multiple projects it allows to provide a different Rocket.Chat channel.
A single library can provide any number of custom steps.


## Task {{% param sectionnumber %}}.2: Use Shared Library (Declarative Syntax)

Now we can rewrite our pipeline to use the new ``notifyPuzzleChat`` step, eliminating any duplicated code. Custom steps are used the same as built-in steps.

Create a new branch named ``lab-11.2`` from branch ``lab-10.1`` (the one we merged the source into) and change the content of the ``Jenkinsfile``:

* define the library with: `@Library('jenkins-techlab-exercise-library') _`
* use your custom pipeline step inside the always block of post.

<!--
```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
```
-->

```
{{< highlight groovy "hl_lines=1 30" >}}
@Library('jenkins-techlab-exercise-library') _

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
        always {
            notifyPuzzleChat('general')
        }
    }
}
{{< / highlight >}}
```

The annotation at the beginning declares that we want to use the library ``jenkins-techlab-exercise-library``.
When a Jenkinsfile only uses steps but no classes from a library it's convention to annotate
the dummy symbol ``_``. A pipeline can use any number of libraries.
Since the step deals with different build results we can also replace the
``success``, ``unstable`` and ``failure`` directives with a single ``always``
directive. Note that ``channel`` is still optional and defaults to the
channel in the Rocket.Chat plugin configuration.


## Task {{% param sectionnumber %}}.3: Use Shared Library (Scripted Syntax)

Simplify our scripted pipeline from the last lab analogously.


## Task {{% param sectionnumber %}}.4: Additional Shared Library Capabilities

In this lab we used folder-level shared libraries to avoid conflicts between
techlab participants. But there are also global, automatic and dynamically loaded
shared libraries.  
Furthermore providing custom steps is just one of several capabilities of shared libraries.
Study the section covering shared libraries in the Jenkins book to learn more
about the different types and capabilities of shared libraries:
<https://jenkins.io/doc/book/pipeline/shared-libraries/>.
