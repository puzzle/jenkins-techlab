Lab 7: Build Parameters
========================

Jobs can be parametrized with user provided input, e.g. to select a deployment target.
When such a job gets started through the web interface a form is presented to the user
where he can provide the necessary arguments.

Lab 7.1: Build Parameters (Declarative Syntax)
-----------------------------------------------

In declarative pipelines parameters are declared with the ``parameters`` section.
Create a new branch named ``lab-7.1`` from branch ``lab-2.1`` and change the contents of the ``Jenkinsfile`` to:

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
    parameters {
        string(name: 'Greetings_to', defaultValue: 'Jenkins Techlab', description: 'Who to greet?')
    }
    stages {
        stage('Greeting') {
            steps {
                echo "Hello, ${params.Greetings_to}!"
            }
        }
    }
}
```

Helper methods like ``string`` or ``booleanParam`` are used to declare the parameter types.
The corresponding documentation should soon be available here: <https://jenkins.io/doc/book/pipeline/syntax/#parameters>.
In the meantime use the snippet generator like described in the next lab to see all available types.

Lab 7.2: Build Parameters (Scripted Syntax)
===========================================

In scripted pipelines build parameters are configured as part of the ``properties`` step.
Create a new branch named ``lab-7.2`` from branch ``lab-2.1`` and change the contents of the ``Jenkinsfile`` to:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5')),
    pipelineTriggers([
        pollSCM('H/5 * * * *'),
        cron('@midnight')
    ]),
    parameters([string(defaultValue: 'Jenkins Techlab', description: 'Who to greet?', name: 'Greetings_to')])
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node {
            stage('Greeting') {
                echo 'Hello, ' + params.Greetings_to + '!'
            }
        }
    }
}
```

Parameter types are declared through the same helper methods as in declarative pipelines.
Use the snippet generator for the ``properties`` step, option "This build is parametrized" to see
all available types.
