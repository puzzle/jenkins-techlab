Lab 7: Build Parameters
========================

Lab 7.1: Build Parameters (Declarative Syntax)
-----------------------------------------------

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
    parameters {
        string(name: 'Greetings_to', defaultValue: 'Jenkins Techlab', description: 'Who to greet?')
    }
    stages {
        stage('Greeting') {
            steps {
                echo 'Hello, ' + params.Greetings_to + '!'
            }
        }
    }
}
```

Lab 7.2: Build Parameters (Scripted Syntax)
============================================

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5')),
    pipelineTriggers([
        pollSCM('H/5 * * * *'),
        cron('@midnight')
    ]),
    parameters([string(defaultValue: 'Jenkins Techlab', description: 'Who to greet?', name: 'Greetings_to')])
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node {
            stage('Greeting') {
                echo 'Hello, ' + params.Greetings_to + '!'
            }
        }
    }
}
```
