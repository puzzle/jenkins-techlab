---
title: "5. String Interpolation and Escaping (Scripted Syntax)"
weight: 2005
sectionnumber: 5
---

**Note** parameters for scripted syntax are defined in the ``properties`` step.

Create a new branch named lab-5.4 from branch lab-2.2 and change the contents of the Jenkinsfile to:

```groovy
node {
    stage('Greeting') {
        def company = 'puzzle'
        echo 'join the ${company}'
        echo "join the ${company}"
        echo '''join the ${company}'''
        echo """join the ${company}"""

        echo "tabulation>\t<"
        echo "backspace>\b<"
        echo "newline>\n<"
        echo "carriage return>\r<"
        echo "form feed>\f<"
        echo "backslash>\\<"
        echo "single quote>\'<"
        echo "double quote>\"<"
    }
}
```

**Note:** Check the build log output on the Jenkins master.


## Task {{% param sectionnumber %}}.2: Using Environment Variables or Parameters within a string in a Pipeline

Create a new branch named lab-5.5 from branch lab-3.2 and change the contents of the Jenkinsfile to:

```groovy
pipeline {
    agent any
    parameters {
        string(name: 'company_parameter', defaultValue: 'puzzle', description: 'The company the pipeline runs in')
    }
    stages {
        stage('Build') {
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL} in company ${params.company_parameter}"
            }
        }
    }
}
```

**Note:** Check the build log output on the Jenkins master.


## Task {{% param sectionnumber %}}.3: Using values as params in a sh command

Create a new branch named lab-5.6 from branch lab-3.2 and change the contents of the Jenkinsfile to:

```groovy
properties([
    parameters([
        string(name: 'COMPANY_PARAMETER', defaultValue: 'puzzle', description: 'The company the pipeline runs in')
    ])
])

node {
    stage('Greeting') {
        sh "echo \"Running ${env.BUILD_ID} on ${env.JENKINS_URL} in company ${params.COMPANY_PARAMETER}\""
    }
}
```

**Note:** Check the build log output on the Jenkins master.
