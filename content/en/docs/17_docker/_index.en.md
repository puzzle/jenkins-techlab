---
title: "17. Docker"
weight: 17
sectionnumber: 17
---


## Task {{% param sectionnumber %}}.1 Dockerfile

Create a new branch named ``lab-17.1`` from branch ``lab-9.1`` (the one we merged the source into).

Create a new file called `Dockerfile` beside the Jenkinsfile (repository root). Copy following content into the dockerfile:

```dockerfile
FROM maven:3.6.3-jdk-11

# Copy complete workspace
COPY . .

# Start maven build
RUN mvn -B -V -U -e clean verify -Dsurefire.useFile=false  -DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true"
```

Modify your `Jenkinsfile`:

<!--
```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
```
-->

```groovy
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
    }
    stages {
        stage('Build') {
            steps {
                sh "docker build -t test-app:latest ."
            }
        }
    }
}
```


### Check build log output

Check the build log (Console Output) of the first run of this pipeline.

* Do you find the pull of the base image?
* Was the build successful?

> You can use every `docker` command inside the pipeline.
