---
title: "9. Artifact Archival (Scripted Syntax)"
weight: 2009
sectionnumber: 9
---


In scripted pipelines you too use the ``archive`` or ``archiveArtifact`` step for artifact archival.
Create a new branch named ``lab-9.4`` from branch ``lab-9.1`` (the one
we merged the source into) and change the contents of the ``Jenkinsfile`` to:

<!--
        node { // with hosted env use node(env.JOB_NAME.split('/')[0])
-->

```groovy
properties([
  buildDiscarder(logRotator(numToKeepStr: '5')),
  disableConcurrentBuilds()
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

In scripted pipelines you have to check out the repository containing the jobs ``Jenkinsfile``
with ``checkout scm``. ``scm`` is a variable referencing the repository containing the ``Jenkinsfile``.  
``junit`` is a special artifact archival step which provides special support
for JUnit test reports. It is also useful outside of JUnit as there are other tools
which generate JUnit test reports, e.g. Selenium or SoapUI.
These examples use the recommended options for Maven in pipeline jobs.
See <https://jenkins.io/doc/pipeline/examples/#maven-and-jdk-specific-version> for details.

**Note:** Check the pipeline screen and build log output on the Jenkins master. The build has also an additional "Test Result" link.
