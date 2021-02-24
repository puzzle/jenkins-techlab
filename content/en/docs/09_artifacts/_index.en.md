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

In declarative pipelines you use the ``archive`` or ``archiveArtifact`` step for artifact archival.

Create a new branch named ``lab-9.1`` from branch ``lab-8.1`` and add some source code into it:

```bash
git pull -s recursive -X ours --allow-unrelated-histories https://github.com/LableOrg/java-maven-junit-helloworld
```

> **Note:** the option ``allow-unrelated-histories`` is necessary since git version ``2.9``

Then configure the Maven build inside the ``Jenkinsfile``.

<!--
```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
```
-->

```
{{< highlight groovy "hl_lines=16-18" >}}
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
    }
    tools {
        jdk 'jdk11'
        maven 'maven36'
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
{{< / highlight >}}
```

Declarative jobs automatically check out the repository containing the jobs ``Jenkinsfile``.

If needed this can be prevented with the ``skipDefaultCheckout()`` build option. ``archiveArtifacts`` copies the given artifacts onto the master and associates them with the current build. When a build is deleted all associated artifacts are deleted too.

``archiveArtifacts`` was introduced with Jenkins 2. It is more flexible than the ``archive`` step and provides additional options like ``exclude``.  


### Check Maven build

Go to the [multibranch pipeline](http://localhost:8080/job/techlab/) of your Jenkins and see, if the pipeline for the new branch is created.

When the job `lab-9.1` is missing, you can click on `Scan Multibranch Pipeline Now` to start the discovery of new branches.

Did the Maven build pass?

Check the new items of the pipeline overview

* ``Last Successful Artifacts``
* ``Latest Test Result``

Check also the build log (Console Output) of the first run of this pipeline and search for

* ``Archiving artifacts``
* ``Recording test results``


## Task {{% param sectionnumber %}}.2: Artifact Archival (Scripted Syntax)

In scripted pipelines you too use the ``archive`` or ``archiveArtifact`` step for artifact archival.
Create a new branch named ``lab-9.2`` from branch ``lab-9.1`` (the one we merged the source into) and change the contents of the ``Jenkinsfile`` to:

<!--
```groovy
...
        node { // with hosted env use node(env.JOB_NAME.split('/')[0])
...
```
-->

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5'))
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node {
            stage('Build') {
                withEnv(["JAVA_HOME=${tool 'jdk11'}", "PATH+MAVEN=${tool 'maven36'}/bin:${env.JAVA_HOME}/bin"]) {
                    checkout scm
                    sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false -DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true"'
                    archiveArtifacts 'target/*.?ar'
                    junit 'target/**/*.xml'  // Requires JUnit plugin
                }
            }
        }
    }
}
```

In scripted pipelines you have to check out the repository containing the jobs ``Jenkinsfile`` with ``checkout scm``. ``scm`` is a variable referencing the repository containing the ``Jenkinsfile``.

``junit`` is a special artifact archival step which provides special support for JUnit test reports. Is is also useful outside of JUnit as there are other tools which generate JUnit test reports, e.g. Selenium or SoapUI.
These examples use the recommended options for Maven in pipeline jobs.
See <https://jenkins.io/doc/pipeline/examples/#maven-and-jdk-specific-version> for details.


### Check Maven build of scripted pipeline

Check the same things as you did by the declarative pipeline (job `lab-9.1`).


## Additional Task {{% param sectionnumber %}}.3: Use Pipeline Maven Integration

The `Pipeline Maven Integration` Plugin adds the `withMaven` step which adds default behavior to your Maven builds.

Install the `Pipeline Maven Integration`:

1. Go to `Dashboard` ➡ `Manage Jenkins` ➡ [Manage Plugins](http://localhost:8080/pluginManager/)
1. Switch to the `Available` tab
1. Enter `Pipeline Maven Integration` into the search field
1. Select the check box in front of the `Pipeline Maven Integration` plugin
1. At the bottom of the page click `Install without restart`

Create a new branch named ``lab-9.3`` from branch ``lab-9.1`` (the one we merged the source into) and change the contents of the ``Jenkinsfile`` to:


<!--
```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
```
-->

```
{{< highlight groovy "hl_lines=16-18" >}}
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
    }
    tools {
        jdk 'jdk11'
        maven 'maven36'
    }
    stages {
        stage('Build') {
            steps {
                withMaven { // Requires Pipeline Maven Integration plugin
                    sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false -DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true"'
                }
            }
        }
    }
}
{{< / highlight >}}
```


### Check withMaven build and log

Check the same things as you did by the declarative pipeline (job `lab-9.1`).

Additional checks:

* Does the job overview look the same?
* Do you see changes in the build log output?
