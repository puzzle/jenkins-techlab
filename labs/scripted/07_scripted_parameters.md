Lab 7.2: Build Parameters (Scripted Syntax)
===========================================

In scripted pipelines build parameters are configured as part of the ``properties`` step.
Create a new branch named ``lab-7.2`` from branch ``lab-3.1`` and change the contents of the ``Jenkinsfile`` to:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5')),
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

**Note:** Use the "Build with Parameters" action on Jenkins master and change the greetings value. The build log output will show the changed greeting.
