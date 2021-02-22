---
title: "6. Environment"
weight: 6
sectionnumber: 6
---

In this lab we see how to work with environment variables in pipelines.

Environment Variable are generally in pipelines available under the ``env`` namespace, like ``env.BUILD_ID``


## Task {{% param sectionnumber %}}.1: Environment (Declarative Syntax)

Create a new branch named ``lab-6.1`` from branch ``lab-3.1`` and change the contents of the ``Jenkinsfile`` to:

```
{{< highlight groovy "hl_lines=9-11 15-18" >}}
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
    }
    environment {
        GREETINGS_TO = 'Jenkins Techlab'
    }
    stages {
        stage('Greeting') {
            steps {
                echo "Hello, ${env.GREETINGS_TO} !"

                // also available as env variable to a process:
                sh 'echo "Hello, $GREETINGS_TO !"'
            }
        }
    }
}
{{< / highlight >}}
```

To add values to the path there is a special syntax

```
        environment {
            PATH+MAVEN = '/path/to/maven'
        }
```

The ``PATH+<IDENTIFIER>`` syntax specifies that the given value should be prepended to the ``PATH`` environment variable, where ``<IDENTIFIER>`` is an arbitrary unique identifier, used to make the left hand side of the assignment unique.


### Check build log output

Go to the newly created pipeline for the new branch on Jenkins master.

Check the build log (Console Output) of the first run of this pipeline.
Does the output meet your expectations?


## Task {{% param sectionnumber %}}.2: Environment (Scripted Syntax)


Create a new branch named ``lab-6.2`` from branch ``lab-6.1`` and replace the content of the ``Jenkinsfile`` with:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5'))
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node {
            stage('Greeting') {
                withEnv(['GREETINGS_TO=Jenkins Techlab']) {
                    echo "Hello, ${env.GREETINGS_TO} !"
                    // also available as env variable to a process:
                    sh 'echo "Hello, $GREETINGS_TO !"'
                }
            }
        }
    }
}
```


### Check build log

Go to the newly created pipeline for the new branch on Jenkins master.

Check the build log (Console Output) of the first run of this pipeline.
Is it identical to {{% param sectionnumber %}}.2?


## Task {{% param sectionnumber %}}.3: Predefined Environment Variables


Jenkins provides a list of predefined environment variables under the path ``/pipeline-syntax/globals#env``. Visit the corresponding link for the techlab environment and study the list:

<http://localhost:8080/pipeline-syntax/globals#env>

<!-- https://jenkins-techlab.ose3-lab.puzzle.ch/pipeline-syntax/globals#env -->

Please note that the list may vary depending on Jenkins version and installed plugins.


### Additional Lab

Update the pipelines from Lab 6 so that the output looks something like this:

```
...
Hello Jenkins Techlab [current build ID]
...
```

Use the string interpolation functionality you've learnt in a previous Lab.

Verify your scripts with the [solution](./06_3_environment_solution/).

