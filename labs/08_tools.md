Lab 8: Tools
============

Jobs usually require specific versions of build tools for build automation, compilation, testing etc.
As soon as you have more than a handful number of tools and versions it becomes impractical to install every version of every tool on all slaves.
That's why Jenkins provides a mechanism to provide the necessary tools for a build on the slaves it runs on.
This lab shows how jobs can declare the tools they need.

?What are default tools? Why do we need custom tools?
?How are they installed and set up?
?What happens when we use a docker image?
?Maybe talk about docker agents as an alternative for custom tools?

Lab 8.1: Tools (Declarative Syntax)
===================================

Declarative pipelines provide a ``tools`` section to declare which
tools a job requires. However, we are currently unable to use the Tools step because
it does not yet support custom tools (Custom Tool Plugin).
The problem is that the installed custom tool is not added to the path.
Until the problem is resolved, we must use the ``withEnv`` and ``tool`` steps.

In this example we use the custom tools jdk8_oracle and maven35.

Create a new branch named ``lab-8.1`` from branch ``lab-2.1`` and change the contents of the ``Jenkinsfile`` to:

?we can reference envs without $?.split() string method outiside script block?
?in a local setup change agent to any?

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
                    sh 'java -version'

                    sh 'mvn --version'
                }
            }
        }
    }
}
```

?Where is the return value of tools step documented? What happens when we do ${xxx}?
?wouldnt it make sense to replace the withEnv with and environment block?

The ``tool`` step returns the home directory of the installed tool. The ``PATH+<IDENTIFIER>`` syntax specifies
that the given value should be prepended to the ``PATH`` environment variable, where ``<IDENTIFIER>`` is an arbitrary
unique identifier, used to make the left hand side of the assignment unique.

The configured tools are downloaded when the job runs, directly onto the slaves it runs on.
Note that tool installers are run for every build and therefore have to be efficient in case the tools are already installed.

Tools step example (not yet working)
------------------------------------

?CustomTools currently has no maintainer. So this is not expected to work anytime soon?

As soon as the problem with the Custom Tool installation is fixed, this code will work.
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
    tools {
        'com.cloudbees.jenkins.plugins.customtools.CustomTool' "jdk8_oracle"
        'com.cloudbees.jenkins.plugins.customtools.CustomTool' "maven35"
    }
    stages {
        stage('Build') {
            steps {
                sh 'java -version'

                sh 'mvn --version'
            }
        }
    }
}
```

The ``tools`` step defines which tools are needed in which version.
The installed tools will be available because their bin directories are added to the ``PATH`` environment variable

Default tool installation example
---------------------------------

This example shows the configuration of a "normal" tool (jdk):
```groovy
tools {
    jdk "jdk8"
}
```

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
                    sh "java -version"

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
