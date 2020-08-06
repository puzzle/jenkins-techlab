Lab 12.2: Credentials (Scripted Syntax)
---------------------------------------

In scripted pipelines you access credentials through the ``withCredentials`` step and various
helper methods like ``usernameColonPassword`` or ``file``.
Create a new branch named ``lab-12.2`` from branch
``lab-9.2`` and change the content of the ``Jenkinsfile`` to:

```groovy
properties([
    buildDiscarder(logRotator(numToKeepStr: '5'))
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        env.ARTIFACT = "${env.JOB_NAME.split('/')[0]}-hello"
        env.REPO_URL = 'https://artifactory.puzzle.ch/artifactory/ext-release-local'
        node { // with hosted env use node(env.JOB_NAME.split('/')[0])
            withCredentials([file(credentialsId: 'm2_settings', variable: 'M2_SETTINGS'), usernameColonPassword(credentialsId: 'jenkins-artifactory', variable: 'ARTIFACTORY'), file(credentialsId: 'known_hosts', variable: 'KNOWN_HOSTS')]) {  // Credentials Binding Plugin
                withEnv(["JAVA_HOME=${tool 'jdk11'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                    stage('Build') {
                        checkout scm
                        sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false -DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true"'
                        sh "mvn -s '${M2_SETTINGS}' -B deploy:deploy-file -DrepositoryId='puzzle-releases' -Durl='${REPO_URL}' -DgroupId='com.puzzleitc.jenkins-techlab' -DartifactId='${ARTIFACT}' -Dversion='1.0' -Dpackaging='jar' -Dfile=`echo target/*.jar`"
                        sshagent(['testserver']) {  // SSH Agent Plugin
                            sh "ls -l target"
                            sh "ssh -o UserKnownHostsFile='${KNOWN_HOSTS}' -p 2222 richard@testserver.vcap.me 'curl -O -u \'${ARTIFACTORY}\' ${REPO_URL}/com/puzzleitc/jenkins-techlab/${ARTIFACT}/1.0/${ARTIFACT}-1.0.jar && ls -l'"
                        }
                        archiveArtifacts 'target/*.?ar'
                        junit 'target/**/*.xml'  // Requires JUnit plugin
                    }
                }
            }
        }
    }
}
```

With ``withCredentials`` you have to use the helper method corresponding to the credential type
you are accessing. See <https://jenkins.io/doc/pipeline/steps/credentials-binding/#withcredentials-bind-credentials-to-variables>
for more information. The available credential types depend on the plugins installed. Visit the ``/pipeline-syntax/`` path
on your server to see only what's actually available, e.g. <https://jenkins-techlab.ose3-lab.puzzle.ch/pipeline-syntax/>
for this techlab.
