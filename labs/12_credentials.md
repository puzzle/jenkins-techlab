Lab 12: Credentials
===================

Build jobs often need credentials for accessing various resources like source code
and artifact repositories, quality control systems, application servers or platforms
and so on. Configuring all necessary credentials on all Jenkins slaves is both impractical and insecure.
So Jenkins provides a mechanism to manage credentials and make them available to jobs
who require them, much like it does with build tools. This mechanism is extensible
and supports various types of credentials like username/password, token, ssh key, secret file etc.

Lab 12.1: Credentials (Declarative Syntax)
------------------------------------------

Declarative pipelines provide the ``credentials`` method which can be used in the ``environment``
section to declare which credentials the job needs and make them available through environment
variables. Create a new branch named ``lab-12.1`` from branch
``lab-9.1`` (the one we merged the source into) and change the content of the ``Jenkinsfile`` to:

```groovy
pipeline {
    agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Requires the "Timestamper Plugin"
    }
    triggers {
        pollSCM('H/5 * * * *')
    }
    environment {
      M2_SETTINGS = credentials('m2_settings')
      KNOWN_HOSTS = credentials('known_hosts')
      ARTIFACTORY = credentials('jenkins-artifactory')
      ARTIFACT = "${env.JOB_NAME.split('/')[0]}-hello"
      REPO_URL = 'https://artifactory.puzzle.ch/artifactory/ext-release-local'
    }
    stages {
        stage('Build') {
            steps {
                withEnv(["JAVA_HOME=${tool 'jdk8_oracle'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                  sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false'
                  sh "mvn -s '${M2_SETTINGS}' -B deploy:deploy-file -DrepositoryId='puzzle-releases' -Durl='${REPO_URL}' -DgroupId='com.puzzleitc.jenkins-techlab' -DartifactId='${ARTIFACT}' -Dversion='1.0' -Dpackaging='jar' -Dfile=`echo target/*.jar`"
                }

                sshagent(['testserver']) {  // SSH Agent Plugin
                  sh "ls -l target"
                  sh "ssh -o UserKnownHostsFile='${KNOWN_HOSTS}' -p 2222 richard@testserver.vcap.me 'curl -O -u \'${ARTIFACTORY}\' ${REPO_URL}/com/puzzleitc/jenkins-techlab/${ARTIFACT}/1.0/${ARTIFACT}-1.0.jar && ls -l'"
                }

                archiveArtifacts 'target/*.?ar'
            }
            post {
                always {
                    junit 'target/**/*.xml'  // JUnit plugin
                }
            }
        }
    }
    post {
        always {
            notifyPuzzleChat()
        }
    }
}
```

``credentials`` automatically deals with different credentials types. For username/password credentials
it makes three environment variables available:
* MYVARNAME = <username>:<password>
* MYVARNAME_USR = <username>
* MYVARNAME_PSW = <password>
In case of a secret file ``MYVARNAME`` contains the filename of a temporary file containing the requested secret.
Additionally we make use of the ``sshagent`` step which managed a dedicated SSH agent with the requested
credential loaded. This is more secure than writing the key into a file and also works in scenarios
where support for alternate ssh key files is missing, e.g. when installing packages in private Git repos through npm.

Lab 12.2: Credentials (Scripted Syntax)
---------------------------------------

In scripted pipelines you access credentials through the ``withCredentials`` step and various
helper methods like ``usernameColonPassword`` or ``file``.
Create a new branch named ``lab-12.2`` from branch
``lab-9.1`` (the one we merged the source into) and change the content of the ``Jenkinsfile`` to:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5')),
    pipelineTriggers([
        pollSCM('H/5 * * * *')
    ])
])

try {
    timestamps() {
        timeout(time: 10, unit: 'MINUTES') {
            env.ARTIFACT = "${env.JOB_NAME.split('/')[0]}-hello"
            env.REPO_URL = 'https://artifactory.puzzle.ch/artifactory/ext-release-local'
            node(env.JOB_NAME.split('/')[0]) {
                stage('Build') {
                    try {
                        withCredentials([file(credentialsId: 'm2_settings', variable: 'M2_SETTINGS'), usernameColonPassword(credentialsId: 'jenkins-artifactory', variable: 'ARTIFACTORY'), file(credentialsId: 'known_hosts', variable: 'KNOWN_HOSTS')]) {  // Credentials Binding Plugin
                            withEnv(["JAVA_HOME=${tool 'jdk8'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                                checkout scm
                                sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false'
                                sh "mvn -s '${M2_SETTINGS}' -B deploy:deploy-file -DrepositoryId='puzzle-releases' -Durl='${REPO_URL}' -DgroupId='com.puzzleitc.jenkins-techlab' -DartifactId='${ARTIFACT}' -Dversion='1.0' -Dpackaging='jar' -Dfile=`echo target/*.jar`"                              
                            }

                        sshagent(['testserver']) {  // SSH Agent Plugin
                            sh "ls -l target"
                            sh "ssh -o UserKnownHostsFile='${KNOWN_HOSTS}' -p 2222 richard@testserver.vcap.me 'curl -O -u \'${ARTIFACTORY}\' ${REPO_URL}/com/puzzleitc/jenkins-techlab/${ARTIFACT}/1.0/${ARTIFACT}-1.0.jar && ls -l'"
                            }
                        }

                        archiveArtifacts 'target/*.?ar'
                    } finally {
                        junit 'target/**/*.xml'  // JUnit Plugin
                    }
                }
            }
        }
    }
} finally {
    notifyPuzzleChat()
}
```

With ``withCredentials`` you have to use the helper method corresponding to the credential type
you are accessing. See <https://jenkins.io/doc/pipeline/steps/credentials-binding/#withcredentials-bind-credentials-to-variables>
for more information. The available credential types depend on the plugins installed. Visit the ``/pipeline-syntax/`` path
on your server to see only what's actually available, e.g. <https://jenkins-techlab.ose3-lab.puzzle.ch/pipeline-syntax/>
for this techlab.
