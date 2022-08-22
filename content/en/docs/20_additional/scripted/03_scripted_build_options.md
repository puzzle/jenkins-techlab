---
title: "3. Build Properties (Scripted Syntax)"
weight: 2003
sectionnumber: 3
---


## Task {{% param sectionnumber %}}.2: Build Properties (Scripted Syntax)

In scripted pipelines build options/properties are configured through the ``properties`` step.
The ``properties`` step replaces any existing build properties with the list given,
therefore only a single instance should be used per pipeline.
Create a new branch named ``lab-3.2`` from branch ``lab-2.1`` and change the contents of the ``Jenkinsfile`` to:

```groovy
properties([
  buildDiscarder(logRotator(numToKeepStr: '5')),
  disableConcurrentBuilds()
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node {
            stage('Greeting') {
                echo 'Hello, World!'
            }
        }
    }
}
```

This configures the same job properties as the declarative pipeline in [Lab 3.1](../../../03_build_options/#task-31-build-options).

In scripted pipelines job properties are configured through steps. The usage of a step depends on its implementation.
Use the "Snippet Generator" ("Pipeline Syntax" in the sidebar) to find the correct syntax.
Scripted pipelines need to run before Jenkins can pick up changes in build properties.
Multibranch pipeline support takes care of this and runs any new jobs and any jobs with changes in their ``Jenkinsfile``.

