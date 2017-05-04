Lab 5: Build Trigger
====================

Like build options/properties triggers need to be configured in the ``Jenkinsfile`` for
multibranch jobs. In this lab we add a SCM polling trigger and a cron trigger to our job.

Lab 5.1: Build Trigger (Declarative Syntax)
-------------------------------------------

In declarative pipelines build triggers are configured through the ``options`` directive.
Only a single ``options`` directive is allowed and must be contained in the ``pipeline`` block.
Create a new branch named ``lab-5.1`` from branch ``lab-4.1`` and change the contents of the ``Jenkinsfile`` to:

```groovy
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Requires the "Timestamper Plugin"
    }
    triggers {
        pollSCM('H/5 * * * *')
        cron('@midnight')
    }
    stages {
        stage('Greeting') {
            steps {
                echo 'Hello, World!'
            }
        }
    }
}
```

``H`` in a cron expression stands for hash (of the job name) and is used to prevent load spikes on Jenkins by distributing job triggering evenly over the configured range.
``@midnight`` also makes use of hashing and actually means some time between 12:00 AM and 2:59 AM. The exact times your job was triggered last and will be triggered next
are shown under "View Configuration."  
For more info regarding Jenkins cron expressions see <http://www.scmgalaxy.com/tutorials/setting-up-the-cron-jobs-in-jenkins-using-build-periodically-scheduling-the-jenins-job>.

Lab 5.2: Build Trigger (Scripted Syntax)
----------------------------------------

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5')),
    pipelineTriggers([
        pollSCM('H/5 * * * *'),
        cron('@midnight')
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
