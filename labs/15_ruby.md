Lab 15: Ruby
============

Lab 15.1: Install Ruby
----------------------

```groovy
pipeline {
    agent {
        // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
        docker {
            image 'ruby:2.7.1'
          }
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
    }
    stages {
        stage('Build') {
            steps {
                sh  """#!/bin/bash
                    ruby --version
                    bundle --version
                """
            }
        }
    }
}
```

Lab 15.2: Improve Ruby Lab
--------------------------

Add additional Ruby lab with tests and artifact archiving.

Lab 15.3: Write Custom Step
---------------------------

Write a custom step to move the above boilerplate code
into a shared library.

---

**End of Lab 15**

<p width="100px" align="right"><a href="16_nodejs.md">Node.js →</a></p>

[← back to overview](../README.md)
