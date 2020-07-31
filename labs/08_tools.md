Lab 8: Tools
============

Jobs usually require specific versions of build tools for build automation, compilation, testing etc.
As soon as you have more than a handful number of tools and versions it becomes impractical to install every version of every tool on all slaves.
That's why Jenkins provides a mechanism to provide the necessary tools for a build on the slaves it runs on.
This lab shows how jobs can declare the tools they need.

Lab 8.1: Default Tools (Declarative Syntax)
===================================

Declarative pipelines provide a ``tools`` section to declare which
tools a job requires. Jenkins per default supports the installation of the following tools:

* JDK
* Maven
* git
* Gradle
* Ant
* Docker

Before a tool can be used in a job it needs to be added to the global tool configuration.

Add a JDK:

1. Go to Manage Jenkins > Global Tool Configuration
2. Under JDK click `Add JDK`
3. Under name enter `jdk8`
4. Check `Install automatically`
5. Under `Add Installer` select `Extract *.zip/*.tar.gz`
  * Under `Download URL for binary archive` enter: "https://download.java.net/openjdk/jdk8u41/ri/openjdk-8u41-b04-linux-x64-14_jan_2020.tar.gz"
  * Under `Subdirectory of extracted archive` enter: "java-se-8u41-ri"
6. At the bottom of the page click `Apply`

Add Maven:

1. Go to Manage Jenkins > Global Tool Configuration
2. Under Maven click `Add Maven`
3. Under name enter `maven35`
4. Check `Install automatically`
5. Under `Install from Apache` select `3.5.0`
6. At the bottom of the page click `Save`

Now we can use Java and Maven in our jobs.

Create a new branch named ``lab-8.1`` from branch ``lab-3.1`` and change the contents of the ``Jenkinsfile`` to:

```groovy
pipeline {
    agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Requires the "Timestamper Plugin"
    }
    tools {
        jdk 'jdk8'
        maven 'maven35'
    }
    stages {
        stage('Build') {
            steps {

                sh 'java -version'

                sh 'javac -version'

                sh 'mvn --version'
            }
        }
    }
}
```

Inside the `tool{}` directive we define which tools are needed and in what version. The installed tools will be available because their bin directories are added to the ``PATH`` environment variable.

The configured tools are downloaded when the job runs, directly onto the slaves it runs on.
Note that tool installers are run for every build and therefore have to be efficient in case the tools are already installed.

However we often need to use other tools not supported by default Jenkins (like rvm or nvm). In this case we have two options; the custom tool plugin and docker agents.

Lab 8.1.1: Custom Tools (Plugin)
===================================

The custom tools plugin enables the installation of any tool to the agent node. We will use it to configure the `nvm` tools we will use in `lab-16`.

1. Under Manage Jenkins > Global Tool Configuration click `Add Custom Tool`
2. Under name enter `nvm`
3. Check `Install automatically`
4. Under `Add Installer` select `Run shell command`
  * Under `Command` enter: "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash"
  * Under `Tool Home` enter: "/${HOME}/.nvm"

The custom tool plugin does not support the `tool{}` directive but we can use the `tool()` step inside an `environment{}` directive to install the tool. The ``tool`` step returns the home directory of the installed tool.

    environment {
        NVM_HOME = tool('nvm')
    }

A full example can be found in `lab-16`.

Lab 8.1.2: Custom Tools (Docker Agent)
===================================

Jenkis can also use a container image as a build environment. In this case all the required tools are present in the image and the source files are mounted in the image.

    agent {
        docker {
            image 'ruby:2.7.1'
        }
    }

We will use this method in `lab-15`


Lab 8.2: Tools (Scripted Syntax)
================================

In scripted pipelines you use the ``tool`` step to install tools.
Create a new branch named ``lab-8.2`` from branch ``lab-3.2`` and change the contents of the ``Jenkinsfile`` to:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5'))
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node(env.JOB_NAME.split('/')[0]) {
            stage('Greeting') {
                withEnv(["JAVA_HOME=${tool 'jdk8'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
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
