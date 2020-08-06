Lab 9: Artifact Archival
========================

Jenkins slaves are to be considered stateless, and depending on the setup, they really are. E.g. when using containerized slaves.
This means that any results of a build that need to be preserved have to be saved before the build ends.
In Jenkins this process is called "artifact archival".
In this lab we archive some build artifacts and test results.

Lab 9.1: Artifact Archival
--------------------------

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

---

**End of Lab 9**

<p width="100px" align="right"><a href="10_failures.md">Failures and Notifications →</a></p>

[← back to overview](../README.md)
