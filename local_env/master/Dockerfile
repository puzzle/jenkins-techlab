FROM jenkins/jenkins:2.375.1

# skip the setup wizard
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false -Dpermissive-script-security.enabled=true -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8"

# install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

USER root

# copy CasC configuration
COPY jenkins.yaml /var/jenkins_casc/jenkins.yaml
COPY agent_connection_key /var/jenkins_casc/secrets/agent_connection_key
RUN chown -R jenkins /var/jenkins_casc

USER jenkins
