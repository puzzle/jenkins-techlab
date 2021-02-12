---
title: "9. Artifact Archival"
weight: 9
sectionnumber: 9
---


Jenkins slaves are to be considered stateless, and depending on the setup, they really are. E.g. when using containerized slaves.
This means that any results of a build that need to be preserved have to be saved before the build ends.
In Jenkins this process is called "artifact archival".
In this lab we archive some build artifacts and test results.


## Task {{% param sectionnumber %}}.1: Artifact Archival (Declarative Syntax)

In declarative pipelines you use the ``archive`` or ``archiveArtifact`` step
for artifact archival.
Create a new branch named ``lab-9.1`` from branch ``lab-8.1`` and add some source
code into it:

```bash
git pull -s recursive -X ours --allow-unrelated-histories https://github.com/LableOrg/java-maven-junit-helloworld
```

**Note:** the option ``allow-unrelated-histories`` is necessary since git version ``2.9``

Then change the contents of the ``Jenkinsfile`` to:

```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Requires the "Timestamper Plugin"
    }
    tools {
        jdk 'jdk11'
        maven 'maven35'
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false -DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true"'
                archiveArtifacts 'target/*.?ar'
                junit 'target/**/*.xml'  // Requires JUnit plugin
            }
        }
    }
}
```

Declarative jobs automatically check out the repository containing the jobs ``Jenkinsfile``.
If needed this can be prevented with the ``skipDefaultCheckout()`` build option.
``archiveArtifacts`` copies the given artifacts onto the master and associates them with
the current build. When a build is deleted all associated artifacts are deleted too.

``archiveArtifacts`` was introduced with Jenkins 2. It is more flexible than the ``archive`` step and provides additional options like ``exclude``.  

**Note:** Check the build log output on the Jenkins master. Search for ``Archiving artifacts`` and ``Recording test results``.
Notify also the new items on the pipeline screen: "Last Successful Artifacts" and "Latest Test Result".


## Task {{% param sectionnumber %}}.2: Artifact Archival (Scripted Syntax)

In scripted pipelines you too use the ``archive`` or ``archiveArtifact`` step for artifact archival.
Create a new branch named ``lab-9.2`` from branch ``lab-9.1`` (the one
we merged the source into) and change the contents of the ``Jenkinsfile`` to:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5'))
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node { // with hosted env use node(env.JOB_NAME.split('/')[0])
            stage('Build') {
                withEnv(["JAVA_HOME=${tool 'jdk8'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                    checkout scm
                    sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false'
                    archiveArtifacts 'target/*.?ar'
                    junit 'target/**/*.xml'  // Requires JUnit plugin
                }
            }
        }
    }
}
```

In scripted pipelines you have to check out the repository containing the jobs ``Jenkinsfile``
with ``checkout scm``. ``scm`` is a variable referencing the repository containing the ``Jenkinsfile``.  
``junit`` is a special artifact archival step which provides special support
for JUnit test reports. Is is also useful outside of JUnit as there are other tools
which generate JUnit test reports, e.g. Selenium or SoapUI.
These examples use the recommended options for Maven in pipeline jobs.
See <https://jenkins.io/doc/pipeline/examples/#maven-and-jdk-specific-version> for details.

**Note:** Check the pipeline screen and build log output on the Jenkins master. The build has also an additional "Test Result" link.
