Lab 13: Stages, Locks and Milestones
====================================

Stages are used to group steps together and to provide boundaries in for pipeline segments which
are also used when visualizing pipelines, e.g. in the Jenkins or OpenShift web interface.
In declarative pipelines some directives like ``post`` or ``agent`` can appear on ``stage`` as well as on the
global level.  
In this lab we split testing and deploying into their own stages and add ``milestone``, ``lock`` and ``input``
steps to control the flow of builds through the pipeline.

Lab 13.1: Stages, Locks and Milestones (Declarative Syntax)
===========================================================

Create a new branch named ``lab-13.1`` from branch
``lab-12.1`` and change the content of the ``Jenkinsfile`` to:

```groovy
@Library('jenkins-techlab-libraries') _

pipeline {
    agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
    }
    environment{
        JAVA_HOME=tool('jdk8_oracle')
        MAVEN_HOME=tool('maven35')
        PATH="${env.JAVA_HOME}/bin:${env.MAVEN_HOME}/bin:${env.PATH}"
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
                    sh 'mvn -B -V -U -e verify -Dsurefire.useFile=false'
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
                sh "mvn -s '${M2_SETTINGS}' -B deploy:deploy-file -DrepositoryId='puzzle-releases' -Durl='${REPO_URL}' -DgroupId='com.puzzleitc.jenkins-techlab' -DartifactId='${ARTIFACT}' -Dversion='1.0' -Dpackaging='jar' -Dfile=`echo target/*.jar`"

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

``milestone`` automatically aborts any earlier builds which haven't yet
reached the milestone. ``lock`` is used to prevent two builds from
using a non-shareable resource like a Selenium server and is most often seen
in test stages. While ``input`` pauses a build and waits for user input.
It accepts the same parameters type as build parameters but can appear
anywhere in a build and allows the parameters to be computed.  
See <https://jenkins.io/blog/2016/10/16/stage-lock-milestone/> for more information.

Lab 13.2: Stages, Locks and Milestones (Scripted Syntax)
--------------------------------------------------------

Adapt scripted pipeline from previous lab analogously.

---

**End of Lab 13**

<p width="100px" align="right"><a href="14_scripted_parts_declarative.md">Scripted Parts in Declarative Pipelines →</a></p>

[← back to overview](../README.md)
