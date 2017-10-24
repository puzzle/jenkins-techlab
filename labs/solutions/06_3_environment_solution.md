Solution Lab 6.3: Environment
=============================

Solutions for [Lab 6.3: Predefined Environment Variables](../06_environment.md#lab-63-predefined-environment-variables)

Extended version of Lab 6.1: Environment (Declarative Syntax)
------------------------------------------------------------------------------

Create a new branch named lab-6.3 from branch lab-6.1 and change the contents of the Jenkinsfile to:

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
                echo "Hello ${env.GREETINGS_TO} ${env.BUILD_ID}"

                // also available as env variable to a process:
                sh 'echo "Hello $GREETINGS_TO $BUILD_ID"'
            }
        }
    }
}
```
**Note:** Check the build log output on the Jenkins master.

Extended version of Lab 6.2: Environment (Scripted Syntax)
----------------------------------------------------------

Create a new branch named lab-6.4 from branch lab-6.2 and change the contents of the Jenkinsfile to:

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
                    echo "Hello ${env.GREETINGS_TO} ${env.BUILD_ID}"

                    // also available as env variable to a process:
                    sh 'echo "Hello $GREETINGS_TO $BUILD_ID"'
                }
            }
        }
    }
}
```
**Note:** Check the build log output on the Jenkins master.

---

[← back to Lab 6](../06_environment.md)
