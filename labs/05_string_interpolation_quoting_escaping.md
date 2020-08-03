Lab 5: String Interpolation and Escaping
========================================

Using the Jenkins Pipelines we quite often need to somehow insert values from variables, parameters,
env variables and so on into a string or a parameter of a function.

Starting with Jenkins Pipelines and the string interpolation rules that are identical to those of [Groovy](http://docs.groovy-lang.org/latest/html/documentation/#all-strings), might be
a bit confusing to many newcomers.

In this lab we are going to cover the following:

* Declaring and using strings
* String interpolation
* Escaping
* Accessing variables, env variables, build and pipeline parameters

How to declare a String
-----------------------

In groovy there are basically four ways on how to declare strings:

```groovy
def singleQuoted = 'Jenkins'
def doubleQuoted = "Pipeline"
def trippleSingleQuoted = '''Techlab'''
def trippleDoubleQuoted = """Techlab"""
```

Only the double quoted strings support string interpolation

```groovy
def company = 'puzzle'
echo 'join the ${company}'
echo "join the ${company}"
echo '''join the ${company}'''
echo """join the ${company}"""
```

Will result in:

```
join the ${company}
join the puzzle
join the ${company}
join the puzzle
```

The tripple quoted (both single and double) string can be multiline

```groovy
def trippleQuoted = '''Jenkins
Pipeline
Techlab'''
echo trippleQuoted
```

or

```groovy
def trippleQuoted = """Jenkins
Pipeline
Techlab"""
echo trippleQuoted
```

Will result in:

```
Jenkins
Pipeline
Techlab
```

Escaping
--------

Escaping a quote in a string

```groovy
def singleQuoted = 'this is a single quote: \' '
def doubleQuoted = "this is a double quote: \" "
```

| Escape sequence | Character |
|---|---|
| \t   | tabulation  |
| \b   | backspace  |
| \n   | newline  |
| \r   | carriage return  |
| \f   | form feed  |
| \\\  | backslash  |
| \\'  | single quote (for single quoted and triple single quoted strings) |
| \\"  | double quote (for double quoted and triple double quoted strings) |

Lab 5.1: Get used to the string interpolation and escaping
----------------------------------------------------------

Use the following example pipeline to play with the string definitions you learned so far

**Note** since we use the declarative pipeline syntax to execute groovy code we use the ``script{...}`` section

Create a new branch named lab-5.1 from branch lab-2.1 and change the contents of the Jenkinsfile to:

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
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
        }
    }
}
```
**Note:** Check the build log output on the Jenkins master.

Lab 5.2: Using Environment Variables or Parameters within a string in a Pipeline
--------------------------------------------------------------------------------

All Environment Variables are available under ``${env.}``

Create a new branch named lab-5.2 from branch lab-2.1 and change the contents of the Jenkinsfile to:

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

Lab 5.3: Using values as params in a sh command
-----------------------------------------------

Working with pipelines we often want to pass a value of a variable into a ``sh`` - command.

For example:
```groovy
def company = 'puzzle'
sh "echo ${company}"
```

Will result in:

```
puzzle
```

Passing only the variable is pretty straight forward. Since we learned the string interpolation only works
for **double quoted** strings, the following

```groovy
def company = 'puzzle'
sh 'echo ${company}'
```

Will result in:

```
${company}
```

which is in this case not what we wanted.

It gets more complicated once you want to pass for example a double quote ``"`` to the shell command. Then the inner quotes must be escaped

```groovy
def company = 'puzzle'
sh "echo \"join the puzzle ${company}\""
```

Here a complete example.

Create a new branch named lab-5.3 from branch lab-2.1 and change the contents of the Jenkinsfile to:

```groovy
pipeline {
    agent any
    parameters {
        string(name: 'company_parameter', defaultValue: 'puzzle', description: 'The company the pipeline runs in')
    }
    stages {
        stage('Build') {
            steps {
                sh "echo \"Running ${env.BUILD_ID} on ${env.JENKINS_URL} in company ${params.company_parameter}\""
            }
        }
    }
}
```
**Note:** Check the build log output on the Jenkins master.

---

**End of Lab 5**

<p width="100px" align="right"><a href="06_environment.md">Environment →</a></p>

[← back to overview](../README.md)
