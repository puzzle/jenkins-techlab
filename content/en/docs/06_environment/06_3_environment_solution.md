---
title: "Solutions - Environment Solution"
weight: 63
sectionnumber: 6.3
description: >
   Solutions for Lab 6.3: Predefined Environment Variables
---


## Extended version of Lab 6.1: Environment (Declarative Syntax)

Create a new branch named lab-6.3 from branch lab-6.1 and change the contents of the ``Jenkinsfile`` to:

```
{{< highlight groovy "hl_lines=15 18" >}}
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
    }
    environment {
        GREETINGS_TO = 'Jenkins Techlab'
    }
    stages {
        stage('Greeting') {
            steps {
                echo "Hello ${env.GREETINGS_TO} ${env.BUILD_ID}"

                // also available as env variable to a process:
                sh 'echo "Hello $GREETINGS_TO $BUILD_ID"'
            }
        }
    }
}
{{< / highlight >}}
```

**Note:** Check the build log output on the Jenkins master.


## Extended version of Lab 6.4: Environment (Scripted Syntax)

Create a new branch named lab-6.4 from branch lab-6.2 and change the contents of the ``Jenkinsfile`` to:

```
{{< highlight groovy "hl_lines=10 13" >}}
properties([
    buildDiscarder(logRotator(numToKeepStr: '5'))
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node {
            stage('Greeting') {
                withEnv(['GREETINGS_TO=Jenkins Techlab']) {
                    echo "Hello ${env.GREETINGS_TO} ${env.BUILD_ID}"

                    // also available as env variable to a process:
                    sh 'echo "Hello $GREETINGS_TO $BUILD_ID"'
                }
            }
        }
    }
}
{{< / highlight >}}
```

**Note:** Check the build log output on the Jenkins master.

---

[← back to Lab 6](../)
