Lab 6: Environment
==================

In this lab we see how to work with environment variables in pipelines.

Enironment Variable are generally in pipelines available under the ``env`` namespace, like ``env.BUILD_ID``

Lab 6.1: Environment (Declarative Syntax)
-----------------------------------------

Create a new branch named lab-6.1 from branch lab-2.1 and change the contents of the Jenkinsfile to:

```groovy
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Requires the "Timestamper Plugin"
    }
    triggers {
        pollSCM('H/5 * * * *')
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
```

Lab 6.2: Environment (Scripted Syntax)
--------------------------------------

Create a new branch named lab-6.2 from branch lab-2.2 and change the contents of the Jenkinsfile to:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5')),
    pipelineTriggers([
        pollSCM('H/5 * * * *')
    ])
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

Lab 6.3: Predefined Environment Variables
-----------------------------------------

Jenkins provides a list of predefined environment variables under the path ``/pipeline-syntax/globals#env``. Visit the corresponding link for the techlab environment and study the list:

<https://jenkins-techlab.ose3-lab.puzzle.ch/pipeline-syntax/globals#env>

Please note that the list may vary depending on Jenkins version and installed plugins.

**Additional Lab:** Update the pipelines from Lab 6 so that the output looks something like this:
```
...
Hello Jenkins Techlab [current build ID]
...
```
Use the string interpolation functionality you've learnt in a previous Lab.

Verify your scripts with the [solution](solutions/06_3_environment_solution.md).

---

**End of Lab 6**

<p width="100px" align="right"><a href="07_parameters.md">Build Parameters →</a></p>

[← back to overview](../README.md)
