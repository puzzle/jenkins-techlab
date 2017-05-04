Lab 6: Tools
============

Jobs usually require specific versions of build tools for build automation, compilation, testing etc.
As soon as you have more than a handful number of tools and versions it becomes impractical to install every version of every tool on all slaves.
That's why Jenkins provides a mechanism to  provide the necessary tools for a build on the slaves it runs on.
This lab shows how jobs can declare the tools they need.

Lab 6.1: Tools (Declarative Syntax)
===================================

```groovy
pipeline {
    agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Requires the "Timestamper Plugin"
    }
    triggers {
        pollSCM('H/5 * * * *')
        cron('@midnight')
    }
    tools {
        maven 'maven35'
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn --version'
            }
        }
    }
}
```
