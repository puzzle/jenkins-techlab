---
title: "4. Build Trigger"
weight: 4
sectionnumber: 4
---

Like build options/properties triggers need to be configured in the ``Jenkinsfile`` for
multibranch jobs. In this lab we add a SCM polling trigger and a cron trigger to our job.


## Task {{% param sectionnumber %}}.1: Build Trigger (Declarative Syntax)

In declarative pipelines build triggers are configured through the ``triggers`` directive.
Only a single ``triggers`` directive is allowed and must be contained in the ``pipeline`` block.

Create a new branch named ``lab-4.1`` from branch ``lab-3.1`` add the triggers block to the ``Jenkinsfile``.

```
{{< highlight groovy "hl_lines=9-11" >}}
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
    }
    triggers {
        pollSCM('H/5 * * * *')
    }
    stages {
        stage('Greeting') {
            steps {
                echo 'Hello, World!'
            }
        }
    }
}
{{< / highlight >}}
```

A cron-like repetitive execution can be configured as followed:

```
triggers {
    cron('@midnight')
}
```

The ``H`` in a cron expression stands for hash (of the job name) and is used to prevent load spikes on Jenkins by distributing job triggering evenly over the configured range.
``@midnight`` also makes use of hashing and actually means some time between 12:00 AM and 2:59 AM. The exact times your job was triggered last and will be triggered next
are shown under "View Configuration."  
For more info regarding Jenkins cron expressions see <http://www.scmgalaxy.com/tutorials/setting-up-the-cron-jobs-in-jenkins-using-build-periodically-scheduling-the-jenins-job>.


### Check trigger configuration

Go to the [multibranch pipeline](http://localhost:8080/job/techlab/) of your Jenkins and see, if the pipeline for the new branch is created.

When the job `lab-4.1` is missing, you can click on `Scan Multibranch Pipeline Now` to start the discovery of new branches.

View the configuration to check, whether the new triggers are now visible in the configuration view.
