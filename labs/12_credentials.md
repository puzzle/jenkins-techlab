Lab 11: Credentials
===================

Lab 11.1: Credentials (Declarative Syntax)
------------------------------------------

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
    tools {
        jdk 'jdk8'
        maven 'maven35'
    }
    environment {      
      KNOWN_HOSTS = credentials('known_hosts')
      ARTIFACTORY = credentials('jenkins-artifactory')
      ARTIFACT = "${env.JOB_NAME.split('/')[0]}-hello"
      REPO_URL = 'https://artifactory.puzzle.ch/artifactory/ext-release-local'
    }
    stages {
        stage('Build') {
            steps {
                git url: "https://github.com/LableOrg/java-maven-junit-helloworld"
                configFileProvider([configFile(fileId: 'm2_settings', variable: 'M2_SETTINGS')]) {  // Requires Config File Provider Plugin
                  sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false'
                  sh "mvn -s '${M2_SETTINGS}' -B deploy:deploy-file -DrepositoryId='puzzle-releases' -Durl='${REPO_URL}' -DgroupId='com.puzzleitc.jenkins-techlab' -DartifactId='${ARTIFACT}' -Dversion='1.0' -Dpackaging='jar' -Dfile=`echo target/*.jar`"
                }
                
                sshagent(['testserver']) {
                  sh "ls -l target"
                  sh "ssh -o UserKnownHostsFile='${KNOWN_HOSTS}' -p 2222 richard@testserver.vcap.me 'curl -O -u \'${ARTIFACTORY}\' ${REPO_URL}/com/puzzleitc/jenkins-techlab/${ARTIFACT}/1.0/${ARTIFACT}-1.0.jar && ls -l'"
                }
                
                archiveArtifacts 'target/*.?ar'
            }
            post {
                always {
                    junit 'target/**/*.xml'  // Requires JUnit plugin
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

The ``credentials`` method makes three environment variables available:
* MYVARNAME = <username>:<password>
* MYVARNAME_USR = <username>
* MYVARNAME_PSW = <password>

Lab 11.2: Credentials (Scripted Syntax)
---------------------------------------

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
                        withCredentials([usernameColonPassword(credentialsId: 'jenkins-artifactory', variable: 'ARTIFACTORY'), file(credentialsId: 'known_hosts', variable: 'KNOWN_HOSTS')]) {
                            withEnv(["JAVA_HOME=${tool 'jdk8'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                                configFileProvider([configFile(fileId: 'm2_settings', variable: 'M2_SETTINGS')]) {  // Config File Provider Plugin
                                    git url: "https://github.com/LableOrg/java-maven-junit-helloworld"
                                    sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false'
                                    sh "mvn -s '${M2_SETTINGS}' -B deploy:deploy-file -DrepositoryId='puzzle-releases' -Durl='${REPO_URL}' -DgroupId='com.puzzleitc.jenkins-techlab' -DartifactId='${ARTIFACT}' -Dversion='1.0' -Dpackaging='jar' -Dfile=`echo target/*.jar`"                              
                                }
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
