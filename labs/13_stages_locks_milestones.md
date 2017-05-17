Lab 13: Stages, Locks and Milestones
====================================

So far we only used a single stage.

Lab 13.1: Stages, Locks and Milestones (Declarative Syntax)
===========================================================

Create a new branch named ``lab-13.1`` from branch
``lab-9.1`` (the one we merged the source into) and change the content of the ``Jenkinsfile`` to:

```groovy
@Library('jenkins-techlab-libraries') _

pipeline {
    agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
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
                milestone(10)  // The first milestone step starts tracking concurrent build order
                sh 'mvn -B -V -U -e clean verify -DskipTests'
            }
        }
        stage('Test') {
            steps {
                // Only one build is allowed to use test resources, newest builds run first
                lock(resource: 'myResource', inversePrecedence: true) {  // Lockable Resources Plugin
                    withEnv(["JAVA_HOME=${tool 'jdk8_oracle'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                        sh 'mvn -B -V -U -e verify -Dsurefire.useFile=false'
                    }
                    milestone(20)  // Abort all older builds that didn't get here
                }
            }
            post {
                always {
                    archiveArtifacts 'target/*.?ar'
                    junit 'target/**/*.xml'  // JUnit Plugin
                }
            }
        }
        stage('Deploy') {
            steps {
                input "Deploy?"
                milestone(30)  // Abort all older builds that didn't get here
                withEnv(["JAVA_HOME=${tool 'jdk8_oracle'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                    sh "mvn -s '${M2_SETTINGS}' -B deploy:deploy-file -DrepositoryId='puzzle-releases' -Durl='${REPO_URL}' -DgroupId='com.puzzleitc.jenkins-techlab' -DartifactId='${ARTIFACT}' -Dversion='1.0' -Dpackaging='jar' -Dfile=`echo target/*.jar`"
                }

                sshagent(['testserver']) {
                    sh "ls -l target"
                    sh "ssh -o UserKnownHostsFile='${KNOWN_HOSTS}' -p 2222 richard@testserver.vcap.me 'curl -O -u \'${ARTIFACTORY}\' ${REPO_URL}/com/puzzleitc/jenkins-techlab/${ARTIFACT}/1.0/${ARTIFACT}-1.0.jar && ls -l'"
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

Lab 13.2: Stages, Locks and Milestones (Scripted Syntax)
--------------------------------------------------------

Adapt scripted pipeline from previous lab analogously.
