---
title: "6. Environment (Scripted Syntax)"
weight: 2006
sectionnumber: 6
---

## Task {{% param sectionnumber %}}.2: Environment (Scripted Syntax)

Create a new branch named lab-6.2 from branch lab-3.2 and change the contents of the Jenkinsfile to:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5'))
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node {
            stage('Greeting') {
                withEnv(['GREETINGS_TO=Jenkins Techlab']) {
                    echo "Hello, ${env.GREETINGS_TO} !"
                    // also available as env variable to a process:
                    sh 'echo "Hello, $GREETINGS_TO !"'
                }
            }
        }
    }
}
```
