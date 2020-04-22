Lab 16: Node.js
===============

```groovy
@Library('jenkins-techlab-libraries') _

pipeline {
    agent { label env.JOB_NAME.split('/')[0] }
    options {
        ansiColor('xterm')  // AnsiColor Plugin
    }
    environment {
        NVM_HOME = tool('nvm')
    }
    stages {
        stage('Build') {
            steps {
                sh """#!/bin/bash +x
                    source \${HOME}/.nvm/nvm.sh
                    nvm install 4
                    node --version
                """
            }
        }
    }
}
```

Lab 16.2: Improve Node.js Lab
-----------------------------

Add additional Node.js lab with tests and artifact archiving.

Lab 16.3: Write Custom Step
---------------------------

Write a custom step to move the above boilerplate code
into a shared library.

---

**End of Lab 16**

<p width="100px" align="right"><a href="17_openshift_pipeline.md">OpenShift Integration →</a></p>

[← back to overview](../README.md)
