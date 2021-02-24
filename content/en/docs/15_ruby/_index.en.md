---
title: "15. Ruby"
weight: 15
sectionnumber: 15
---


## Task {{% param sectionnumber %}}.1: Install Ruby (Declarative Syntax)

```groovy
pipeline {
    agent {
        // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
        docker {
            image 'ruby:2.7.1'
          }
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
    }
    stages {
        stage('Build') {
            steps {
                sh  """#!/bin/bash
                    ruby --version
                    bundle --version
                """
            }
        }
    }
}
```


## Task {{% param sectionnumber %}}.2: Write Custom Step

Write a custom step to move the above boilerplate code
into a shared library.
