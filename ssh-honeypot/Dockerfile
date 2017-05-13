FROM jenkins
USER root
RUN yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum repolist && \
    yum -y install --enablerepo=rhel-7-server-optional-rpms gcc git python-devel libffi-devel openssl-devel openssl gmp-devel mpfr-devel libmpc-devel && \
    yum -y clean all
ENV HOME=/home/cowrie PYTHONPATH=/home/cowrie/cowrie REFRESHED_AT=2017051001
RUN curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python && \
    mkdir -p /home/cowrie && \
    cd /home/cowrie && \
    git clone https://github.com/dtschan/cowrie.git /home/cowrie/cowrie && \
    cd cowrie && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" >data/authorized_keys && \
    pip install -U -r requirements.txt && \
    echo 'Welcome to the techlab test server!' >/home/richard/welcome.txt
    echo touch /home/richard/welcome.txt | bin/fsctl data/fs.pickle
    fix-permissions /home/cowrie
USER 1001
COPY cowrie.cfg.skel /home/cowrie/cowrie/
ENV HOME=${JENKINS_HOME}
EXPOSE 2222
COPY docker-entrypoint.sh /cowrie.sh
ENTRYPOINT ["/bin/sh", "-c", "/cowrie.sh & /usr/libexec/s2i/run"]
