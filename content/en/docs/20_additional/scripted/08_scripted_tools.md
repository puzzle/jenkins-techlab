---
title: "8. Tools (Scripted Syntax)"
weight: 2008
sectionnumber: 8
---


In scripted pipelines you use the ``tool`` step to install tools.
Create a new branch named ``lab-8.2`` from branch ``lab-3.2`` and change the contents of the ``Jenkinsfile`` to:

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
            stage('Greeting') {
                withEnv(["JAVA_HOME=${tool 'jdk11'}", "PATH+MAVEN=${tool 'maven36'}/bin:${env.JAVA_HOME}/bin"]) {
                    sh "java -version"
                    sh "mvn --version"
                }
            }
        }
    }
}
```

The usage of tools is identical to the previous lab since we couldn't use the declarative syntax there.
