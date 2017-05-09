FROM jenkins
USER root
ENV HOME=/home/cowrie PYTHON_PATH=/home/cowrie/cowrie
RUN yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum repolist && \
    yum -y install --enablerepo=rhel-7-server-optional-rpms gcc git python-devel libffi-devel openssl-devel openssl gmp-devel mpfr-devel libmpc-devel && \
    yum -y clean all && \
    useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin -c "Default Application User" default
RUN curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python && \
    mkdir -p /home/cowrie && \
    cd /home/cowrie && \
    git clone --branch v1.1.0 https://github.com/micheloosterhof/cowrie.git /home/cowrie/cowrie && \
    cd cowrie && \
    pip install -U -r requirements.txt && \
    fix-permissions /home/cowrie
USER 1001
COPY cowrie.cfg.skel /home/cowrie/cowrie/
ENV HOME=${JENKINS_HOME}
EXPOSE 2222
COPY docker-entrypoint.sh /
