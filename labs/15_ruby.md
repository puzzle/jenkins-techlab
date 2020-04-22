Lab 15: Ruby
============

Lab 15.1: Install Ruby (Declarative Syntax)
-------------------------------------------

```groovy
@Library('jenkins-techlab-libraries') _

pipeline {
    agent { label env.JOB_NAME.split('/')[0] }
    environment {
        RVM_HOME = tool('rvm')
    }
    stages {
        stage('Build') {
            steps {
                sh  """#!/bin/bash
                    source \${RVM_HOME}/scripts/rvm
                    rvm use --install 2.3.4
                    gem list '^bundler\$' -i || gem install bundler
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
