---
title: "16. Node.js"
weight: 16
sectionnumber: 16
---


```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
    }
    environment {
        NVM_HOME = tool('nvm')
    }
    stages {
        stage('Build') {
            steps {
                sh """#!/bin/bash +x
                    source \${HOME}/.nvm/nvm.sh
                    nvm install 4
                    node --version
                """
            }
        }
    }
}
```


## Task {{% param sectionnumber %}}.2: Improve Node.js Lab

Add additional Node.js lab with tests and artifact archiving.


## Task {{% param sectionnumber %}}.3: Write Custom Step

Write a custom step to move the above boilerplate code
into a shared library.

