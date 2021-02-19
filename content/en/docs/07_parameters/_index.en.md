---
title: "7. Build Parameters"
weight: 7
sectionnumber: 7
---


Jobs can be parametrized with user provided input, e.g. to select a deployment target.
When such a job gets started through the web interface a form is presented to the user
where he can provide the necessary arguments.


## Task {{% param sectionnumber %}}.1: Build Parameters (Declarative Syntax)


In declarative pipelines, parameters are declared with the ``parameters`` section.

Create a new branch named ``lab-7.1`` from branch ``lab-3.1`` and change the contents of the ``Jenkinsfile`` to:

```
{{< highlight groovy "hl_lines=9-11 15" >}}
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
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
{{< / highlight >}}
```

Helper methods like ``string`` or ``booleanParam`` are used to declare the parameter types.
The corresponding documentation is available here: <https://jenkins.io/doc/book/pipeline/syntax/#parameters>.

You can also use the snippet generator, like described in the next lab, to see all available types.


### Use parameters

Go to the newly created pipeline for the new branch on Jenkins master.

The first stage of the pipeline has to be run successfully such that the parameter is configured in the job.
Then you can use the "Build with Parameters" action.

Change the greetings value. The build log output will show the changed greeting.
