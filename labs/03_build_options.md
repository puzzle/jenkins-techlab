# Lab 3: Build Options/Properties

When using multibranch pipelines you can no longer configure build options (declarative syntax)
or build properties (scripted syntax) through the web interface. For single branch ``Jenkinsfile``
pipelines configuring build options/properties in the ``Jenkinsfile`` is recommended as well in
order to obtain a single source of truth <https://en.wikipedia.org/wiki/Single_source_of_truth>.
This lab shows how this is done.

## Lab 3.1: Build Options

In declarative pipelines build options/properties are configured through the ``options`` directive.
Only a single ``options`` directive is allowed and must be contained in the ``pipeline`` block.
Create a new branch named ``lab-3.1`` from branch ``lab-2.1`` and change the contents of the ``Jenkinsfile`` to:

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
        stage('Greeting') {
            steps {
                echo 'Hello, World!'
            }
        }
    }
}
```

This pipeline is configured to:

* Keep a maximum of **5** builds
* Timeout builds that run longer than **10 minutes**
* Print timestamps before each build log line
  * Uses the Timestamper Jenkins Plugin <https://wiki.jenkins.io/display/JENKINS/Timestamper>
* Disallow concurrent executions of the Pipeline. Can be useful for preventing multiple simultaneously builds for one branch. However locks and milestones are the preferred solution for this because they allow newer builds to supersede older ones. This is especially important for longer builds and builds requesting user input. Also see [Lab 13](13_stages_locks_milestones.md).

**Note:** The timeout option isn't shown in the configuration on the Jenkins master

---

**End of Lab 3**

<p width="100px" align="right"><a href="04_build_triggers.md">Build Trigger configuration →</a></p>

[← back to overview](../README.md)
