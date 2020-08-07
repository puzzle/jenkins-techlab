Lab 12: Credentials
===================

Build jobs often need credentials for accessing various resources like source code
and artifact repositories, quality control systems, application servers or platforms
and so on. Configuring all necessary credentials on all Jenkins slaves is both impractical and insecure.
So Jenkins provides a mechanism to manage credentials and make them available to jobs
who require them, much like it does with build tools. This mechanism is extensible
and supports various types of credentials like username/password, token, ssh key, secret file etc.

Lab 12.1: Local SSH Server setup
---------------------


1. Generate SSH Keypair. Run following command to create the Keypair (Select the default key type *ecdsa*)
    ```
    docker run --rm -it --entrypoint /keygen.sh linuxserver/openssh-server
    ```
    You should see following ouput (example is truncated):
    ```
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAArAAAABNlY2RzYS
    1zaGEyLW5pc3RwNTIxAAAACG5pc3RwNTIxAAAAhQQBvn9dc6qeTqaz/X5iFafmOo8f18++
    .....
    ....
    ...
    Kh5vtHhHEzKQm4vf9moTQCcyw6JbcB3JezTrlOQAIRNudnxbqNhNNMaLGjsv2VP1AAAAEX
    Jvb3RAMzQzYzBhMTcwNzZlAQI=
    -----END OPENSSH PRIVATE KEY-----
    ecdsa-sha2-nistp521 AAAAE2Vj.....C4+Q== root@343c0a17076e
    ```

2. Set the public key as environment variable in order to substitute the placeholder inside the ssh-server-compose file
    ```
    export PUB_KEY=ecdsa-sha2-nistp521 AAAAE2VjZH.......
    ```

3. Open the Jenkins web gui, press `Manage Jenkins` → `Manage Credentials` and select the Global credentials from the list. Then click on `Add Credentials` in the left menu. 

    ```
    Kind: SSH Username with private key
    ID: artifact-ssh
    Username: puzzler
    Private Key: [x] Enter directly
    ```
    Click on Add key and paste the private key generated in the previous step.


4. Start a local SSH Server instance with docker. Depending on your Docker installation you may need to run this command with `sudo`:

    ```
    docker-compose -f local_env/ssh-server-compose.yaml up -d
    ```

Lab 12.2: Credentials
---------------------

Declarative pipelines provide the ``credentials`` method which can be used in the ``environment``
section to declare which credentials the job needs and make them available through environment
variables. Create a new branch named ``lab-12.1`` from branch ``lab-9.1``
 (the one we merged the source into) and change the content of the ``Jenkinsfile`` to:

```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Requires the "Timestamper Plugin"
    }
    environment{
        ARTIFACT = "${env.JOB_NAME.split('/')[0]}-hello"
    }
    tools {
        jdk 'jdk11'
        maven 'maven35'
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false  -DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true"'
                sshagent(['artifact-ssh']) {  // SSH Agent Plugin, artifact-ssh references the SSH credentials 
                    sh 'ssh-keyscan -p 2222 openssh-server > ~/.ssh/known_hosts'
                    sh 'ssh -p 2222 puzzler@openssh-server "whoami"'
                    sh 'ssh -p 2222 puzzler@openssh-server "mkdir -p ~/jenkins-techlab/${ARTIFACT}/1.0/"' 
                    sh "scp -P 2222 target/*.jar  puzzler@openssh-server:~/jenkins-techlab/${ARTIFACT}/1.0/"
                }
                archiveArtifacts 'target/*.?ar'
                junit 'target/**/*.xml'  // Requires JUnit plugin
            }
        }
    }
}
```

``credentials`` automatically deals with different credentials types. For username/password credentials
it makes three environment variables available:
* MYVARNAME = <username>:<password>
* MYVARNAME_USR = <username>
* MYVARNAME_PSW = <password>
In case of a secret file ``MYVARNAME`` contains the filename of a temporary file containing the requested secret.
Additionally we make use of the ``sshagent`` step which managed a dedicated SSH agent with the requested
credential loaded. This is more secure than writing the key into a file and also works in scenarios
where support for alternate ssh key files is missing, e.g. when installing packages in private Git repos through npm.

---

**End of Lab 12**

<p width="100px" align="right"><a href="13_stages_locks_milestones.md">Stages, Locks and Milestones →</a></p>

[← back to overview](../README.md)


