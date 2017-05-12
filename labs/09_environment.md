Lab 9: Environment
==================

In this lab we see how to work with environment variables in pipelines.

Lab 9.1: Environment (Declarative Syntax)
-----------------------------------------

(Based on lab 5):

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
        cron('@midnight')
    }
    environment {
        GREETINGS_TO = 'Jenkins Techlab'
    }
    stages {
        stage('Greeting') {
            steps {
                echo 'Hello, ' + env.GREETINGS_TO + '!'
            }
        }
    }
}
```

Lab 9.2: Environment (Scripted Syntax)
--------------------------------------

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5')),
    pipelineTriggers([
        pollSCM('H/5 * * * *'),
        cron('@midnight')
    ])
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node {
            stage('Greeting') {
                withEnv(['GREETINGS_TO=Jenkins Techlab']) {
                    echo 'Hello, ' + env.GREETINGS_TO + '!'
                }
            }
        }
    }
}
```
