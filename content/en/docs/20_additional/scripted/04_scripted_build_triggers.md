---
title: "4. Build Trigger (Scripted Syntax)"
weight: 2004
sectionnumber: 4
---

## Task {{% param sectionnumber %}}.2: Build Trigger (Scripted Syntax)

Create a new branch named ``lab-4.2`` from branch ``lab-3.2`` and change the contents of the ``Jenkinsfile`` to:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5')),
    pipelineTriggers([
        pollSCM('H/5 * * * *')
    ])
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

Changes in build triggers in scripted pipelines are only seen by Jenkins
after the changed pipeline ran.

**Note:** Verify on the Jenkins master, whether the new triggers are now visible in the configuration view.
