Lab 13: Ruby
============

Lab 13.1: Install Ruby (Declarative Syntax)
-------------------------------------------

```groovy
@Library('jenkins-techlab-libraries') _

pipeline {
    agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
    }
    triggers {
        pollSCM('H/5 * * * *')
    }
    environment {
        RVM_HOME = tool('rvm')
    }
    stages {
        stage('Build') {
            steps {
                sh  """#!/bin/bash
                    source \${RVM_HOME}/scripts/rvm
                    rvm use --install 2.3.4
                    gem list '^bundler\$' -i || gem install bundler
                    ruby --version
                    bundle --version
                """
            }
        }
    }
    post {
        always {
            notifyPuzzleChat()
        }
    }
}
```

Lab 14.2: Improve Ruby Lab
--------------------------

Add additional Ruby lab with tests and artifact archiving.

Lab 14.3: Write Custom Step
---------------------------

Write a custom step to move the above boilerplate code
into a shared library.
