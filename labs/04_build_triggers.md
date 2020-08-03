Lab 4: Build Trigger
====================

Like build options/properties triggers need to be configured in the ``Jenkinsfile`` for
multibranch jobs. In this lab we add a SCM polling trigger and a cron trigger to our job.

Lab 4.1: Build Trigger
----------------------

In declarative pipelines build triggers are configured through the ``triggers`` directive.
Only a single ``triggers`` directive is allowed and must be contained in the ``pipeline`` block.
Create a new branch named ``lab-4.1`` from branch ``lab-3.1`` and change the contents of the ``Jenkinsfile`` to:

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
A cronlike repetitive execution can be configured as followed:
```
triggers {
    cron('@midnight')
}
```

``H`` in a cron expression stands for hash (of the job name) and is used to prevent load spikes on Jenkins by distributing job triggering evenly over the configured range.
``@midnight`` also makes use of hashing and actually means some time between 12:00 AM and 2:59 AM. The exact times your job was triggered last and will be triggered next
are shown under "View Configuration."  
For more info regarding Jenkins cron expressions see <http://www.scmgalaxy.com/tutorials/setting-up-the-cron-jobs-in-jenkins-using-build-periodically-scheduling-the-jenins-job>.

**Note:** Verify on the Jenkins master, whether the new triggers are now visible in the configuration view.

---

**End of Lab 4**

<p width="100px" align="right"><a href="05_string_interpolation_quoting_escaping.md">String Interpolation and Escaping →</a></p>

[← back to overview](../README.md)
