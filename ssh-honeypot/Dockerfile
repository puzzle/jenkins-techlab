FROM jenkins
USER root
ENV HOME=/home/cowrie PYTHONPATH=/home/cowrie/cowrie
RUN yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum repolist && \
    yum -y install --enablerepo=rhel-7-server-optional-rpms gcc git python-devel libffi-devel openssl-devel openssl gmp-devel mpfr-devel libmpc-devel && \
    yum -y clean all && \
    useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin -c "Default Application User" default && \
    curl https://raw.githubusercontent.com/appuio/libmapuid/master/lib/libmapuid.so -o /usr/local/lib/libmapuid.so && \
    chmod 755 /usr/local/lib/libmapuid.so
RUN curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python && \
    mkdir -p /home/cowrie && \
    cd /home/cowrie && \
    git clone https://github.com/dtschan/cowrie.git /home/cowrie/cowrie && \
    cd cowrie && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA3c4syMdGL/SDfeWZOJuFDioKtbBf3W86yVweqvDck8Uy3RDzwRBHf+TeyMxt/EDMNqRch80/RDQpu4nVZVZ30DjL4yM1O19bTSqROmPVOMHpBbx1RBeIcl4blBIOWnN9o9QeHEnDc5TAV9uPISXwLc0+Qcd1Y5PpoCQWVJzRbL0MuXnKbKdKTSWz9aj+z+brnOhW6L+M08yR6AQW/CXkympmihrIsh7y9IPNZWAYBultLgKghVSvmjHXCm3qcOi+P3ZC7Jg1FQCVBu9vLHE2nplWd0jyXGuVQeCeQjuncsCWM1GXW6JBVDidc+RVxAgm7H1Y4K0zLprJ2B4yOgHtyw== tschan@tschan7.lan" >data/authorized_keys && \
    pip install -U -r requirements.txt && \
    fix-permissions /home/cowrie
USER 1001
COPY cowrie.cfg.skel /home/cowrie/cowrie/
ENV HOME=${JENKINS_HOME}
EXPOSE 2222
COPY docker-entrypoint.sh /
