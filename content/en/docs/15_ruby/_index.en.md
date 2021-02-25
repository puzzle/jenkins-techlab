---
title: "15. Ruby"
weight: 15
sectionnumber: 15
---

In this lab you will learn how to use a container image to build a Ruby application.


## Task {{% param sectionnumber %}}.1: Use Ruby Container

We use a docker image as our agent. This is possible because we have a slave which is capable to run container images.

Create a new branch named ``lab-15.1`` from branch ``lab-8.1`` and change the content of the ``Jenkinsfile`` to:

<!--
```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
```
-->

```groovy
pipeline {
    agent {
        docker {
            image 'ruby:2.7.1'
          }
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
    }
    stages {
        stage('Info') {
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


### Check build log output

Check the build log (Console Output) of the first run of this pipeline.

* Do you see the pull of the ruby:2.7.1 container image?
* Are the versions correct?


## Task {{% param sectionnumber %}}.2: Build Ruby Application

Add some source code to your branch ``lab-18.1``:

```bash
git pull -s recursive -X ours --allow-unrelated-histories https://github.com/sclorg/ruby-ex.git
```

> **Note:** the option ``allow-unrelated-histories`` is necessary since git version ``2.9``

Then configure the Ruby build inside the ``Jenkinsfile`` by adding the build stage:

```groovy
        stage('Build') {
            steps {
                sh 'bundle install'
            }
        }
```

<!--

## Task {{% param sectionnumber %}}.3: Test Ruby Application

Add the test stage to your ``Jenkinsfile``.

```groovy
        stage('Test') {
            steps {
                sh 'rake ci:all'
            }
        }
```
-->


## Additional Task {{% param sectionnumber %}}.3: Write Custom Step

Write a custom step to move the above boilerplate code into a shared library.
