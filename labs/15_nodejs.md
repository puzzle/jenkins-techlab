Lab 14: Node.js
===============

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
        NVM_HOME = tool('nvm')
    }
    stages {
        stage('Build') {
            steps {
                ansiColor('xterm') {  // AnsiColor Plugin
                    sh """#!/bin/bash +x
                        source \${HOME}/.nvm/nvm.sh
                        nvm install 4
                        node --version
                    """
                }
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
