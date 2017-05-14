FROM jenkins
USER root
RUN yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum repolist && \
    yum -y install --enablerepo=rhel-7-server-optional-rpms gcc git python-devel libffi-devel openssl-devel openssl gmp-devel mpfr-devel libmpc-devel && \
    yum -y clean all
ENV HOME=/home/cowrie PYTHONPATH=/home/cowrie/cowrie REFRESHED_AT=2017051401
RUN curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python && \
    mkdir -p /home/cowrie && \
    cd /home/cowrie && \
    git clone https://github.com/dtschan/cowrie.git /home/cowrie/cowrie && \
    cd cowrie && \
    pip install -U -r requirements.txt && \
    mkdir -p honeyfs/home/richard && \
    echo 'Welcome to the techlab test server!' >honeyfs/home/richard/welcome.txt && \
    echo touch /home/richard/welcome.txt | bin/fsctl data/fs.pickle && \
    fix-permissions /home/cowrie
USER 1001
COPY data/* /home/cowrie/cowrie/data/
COPY cowrie.cfg.skel /home/cowrie/cowrie/
ENV HOME=${JENKINS_HOME}
EXPOSE 2222
COPY docker-entrypoint.sh /cowrie.sh
ENTRYPOINT ["/bin/sh", "-c", "/cowrie.sh & /usr/libexec/s2i/run"]
