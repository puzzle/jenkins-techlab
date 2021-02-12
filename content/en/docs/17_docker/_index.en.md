---
title: "17. Docker"
weight: 17
sectionnumber: 17
---



## Task {{% param sectionnumber %}}.1 Dockerfile

Create a new file called `Dockerfile` inside the maven project root. Copy following content into the dockerfile

```dockerfile
FROM maven:3.6.3-jdk-11 #Base image

COPY . . #Copy complete workspace

RUN mvn -B -V -U -e clean verify -Dsurefire.useFile=false  -DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true" #Start maven build

```

Modify your Jenkinsfile

```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
    }
    environment {

    }
    stages {
        stage('Build') {
            steps {
                sh "docker build -t gitlab.puzzle.ch/testimage/image:latest ."
            }
        }
    }
}
```

You can use every `docker` command inside the pipeline.
