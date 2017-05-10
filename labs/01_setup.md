Lab 1: Setup
============

The techlab setup involves starting a Jenkins Slave on your notebook and connecting it
to a Jenkins master running on an OpenShift 3 environment. An OpenShift client is needed
to establish the connection.

Environment
-----------

Set environment variables with your techlab username and password:

    export TLUSER=<myusername>
    export TLPASS=<mypassword>

OpenShift Client
----------------

1. Follow the instructions here to install the OpenShift 3 client:
<https://docs.openshift.org/latest/cli_reference/get_started_cli.html#installing-the-cli>

2. Log into OpenShift:

        oc login ose3-lab-master.puzzle.ch:8443 -u ${TLUSER} -p "${TLPASS}"

3. Forward the JNLP port required for Jenkins Master <-> Slave communication

        oc project pitc-jenkins-techlab
        while oc port-forward `oc get pod -l name=jenkins -o jsonpath='{.items[0].metadata.name}'` 50000:50000 2222:2222; do :; done

The ``while`` loop  is required because currently port-forward connections time out after one hour.
Press ``CTRL-C`` ``CTRL-C`` to stop.

Jenkins Slave
-------------

**With Docker**

    docker run --net=host csanchez/jenkins-swarm-slave -master https://jenkins-techlab.ose3-lab.puzzle.ch/ -disableSslVerification -tunnel localhost:50000 -executors 2 -name ${TLUSER} -labels ${TLUSER} -username ${TLUSER} -password "${TLPASS}"

**Directly on your machine or in a VM**

1. Create a dedicated, unprivileged user:

        sudo useradd jenkins-slave

2. Download Jenkins swarm client 3.4 into a location accessible by the new user:

        curl -O https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.4/swarm-client-3.4.jar

3. Start Jenkins slave with new user:

        sudo -u jenkins-slave -i java -jar swarm-client-3.4.jar -master https://jenkins-techlab.ose3-lab.puzzle.ch/ -disableSslVerification -tunnel localhost:50000 -executors 2 -name ${TLUSER} -labels ${TLUSER} -username ${TLUSER} -password "${TLPASS}"

**Warning:** Running the Jenkins slave directly on your machine with your default user
will give techlab participants access to all your files.
