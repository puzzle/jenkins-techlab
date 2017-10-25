Lab 8: Tools
============

Jobs usually require specific versions of build tools for build automation, compilation, testing etc.
As soon as you have more than a handful number of tools and versions it becomes impractical to install every version of every tool on all slaves.
That's why Jenkins provides a mechanism to provide the necessary tools for a build on the slaves it runs on.
This lab shows how jobs can declare the tools they need.

Lab 8.1: Tools (Declarative Syntax)
===================================

Declarative pipelines provide a ``tools`` section to declare which
tools a job requires. However we currently can't use it because
it doesn't yet support custom tools (Custom Tool Plugin). Instead
we use the ``withEnv`` and ``tool`` steps.
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
    }
    stages {
        stage('Build') {
            steps {
                withEnv(["JAVA_HOME=${tool 'jdk8_oracle'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                    sh 'mvn --version'
                }
            }
        }
    }
}
```

The ``tool`` step returns the home directory of the installed tool. The ``PATH+<IDENTIFIER>`` syntax specifies
that the given value should be prepended to the ``PATH`` environment variable, where ``<IDENTIFIER>`` is an arbitraty
unique identifier, used to make the left hand side of the assignment unique.
The configured tools are downloaded when the job runs, directly onto the slaves it runs on.
Note that tool installers are run for every build and therefore have to be efficient in case the tools are already installed.

Lab 8.2: Tools (Scripted Syntax)
================================

In scripted pipelines you use the ``tool`` step to install tools.
Create a new branch named ``lab-8.2`` from branch ``lab-2.2`` and change the contents of the ``Jenkinsfile`` to:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5')),
    pipelineTriggers([
        pollSCM('H/5 * * * *')
    ])
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node(env.JOB_NAME.split('/')[0]) {
            stage('Greeting') {
                withEnv(["JAVA_HOME=${tool 'jdk8_oracle'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                    sh "mvn --version"
                }
            }
        }
    }
}
```

The usage of tools is identical to the previous lab since we couldn't use the declarative syntax there.

---

**End of Lab 8**

<p width="100px" align="right"><a href="09_artifacts.md">Artifact Archival →</a></p>

[← back to overview](../README.md)
