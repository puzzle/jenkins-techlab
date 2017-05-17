Lab 8: Tools
============

Jobs usually require specific versions of build tools for build automation, compilation, testing etc.
As soon as you have more than a handful number of tools and versions it becomes impractical to install every version of every tool on all slaves.
That's why Jenkins provides a mechanism to provide the necessary tools for a build on the slaves it runs on.
This lab shows how jobs can declare the tools they need.

Lab 8.1: Tools (Declarative Syntax)
===================================

In declarative pipelines you use the ``tools`` directory to declare which
tools a job requires.
Create a new branch named ``lab-8.1`` from branch ``lab-2.1`` and change the contents of the ``Jenkinsfile`` to:

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
        jdk 'jdk8'
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

The configured tools are downloaded when the job runs, directly onto the slaves it runs on.
With the declarative syntax environment variables like ``PATH`` and ``JAVA_HOME`` are
configured automatically as requested by the tool installer. Note that tool installers
are run for every build and therefore have to be efficient in case the tools are already installed.

Lab 8.2: Tools (Scripted Syntax)
================================

In scripted pipelines you use the ``tool`` step to install tools.
Create a new branch named ``lab-8.2`` from branch ``lab-2.2`` and change the contents of the ``Jenkinsfile`` to:

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
        node(env.JOB_NAME.split('/')[0]) {
            stage('Greeting') {
                withEnv(["JAVA_HOME=${tool 'jdk8'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                    sh "mvn --version"
                }
            }
        }
    }
}
```

With the scripted syntax you have to use the ``withEnv`` step to configure the necessary environment variables. The ``tool`` step returns the home directory
of the installed tool.
