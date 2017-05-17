Lab 13: Ruby
============

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

Add additional Ruby lab with tests and artifact archiving.
