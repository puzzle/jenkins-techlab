---
title: "16. Node.js"
weight: 16
sectionnumber: 16
---

In this lab you will build a Node.js application.


## Task {{% param sectionnumber %}}.1: Use nvm tool

You added the nvm tool in lab 8.

Create a new branch named ``lab-16.1`` from branch ``lab-8.1`` and change the content of the ``Jenkinsfile`` to:

<!--
```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
```
-->

```groovy
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
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


### Check build log output

Check the build log (Console Output) of the first run of this pipeline.

* Do you find the tool installation?
* Are the versions correct?


## Additional Task {{% param sectionnumber %}}.3: Write Custom Step

Write a custom step to move the above boilerplate code into a shared library.
