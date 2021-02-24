---
title: "18. OpenShift Integration"
weight: 18
sectionnumber: 18
description: >
   OpenShift integrates quite nicely with the Jenkins pipelines.
---

> For this lab you need to have access to an OpenShift cluster.


## Pipelines on OpenShift

With Pipelines on OpenShift you have the possibility to fully integrate complex CI/CD processes. This is done by creating BuildConfigurations that define pipelines.

The official documentation can be found at [Pipeline build](https://docs.openshift.com/container-platform/latest/builds/build-strategies.html#builds-strategy-pipeline-build_build-strategies) or [OpenShift 3 Pipeline Builds](https://docs.openshift.com/container-platform/3.11/dev_guide/dev_tutorials/openshift_pipeline.html).

Since OpenShift platform version 4 the integrated pipeline builds rely on [Tekton](https://tekton.dev/).
These Tekton based pipelines are only available as a Technology Preview Feature [OpenShift 4 Pipeline Builds](https://docs.openshift.com/container-platform/latest/pipelines/understanding-openshift-pipelines.html).


### Use external Jenkins

Is is common usage to orchestrate an OpenShift plattform from an external Jenkins.


## Task {{% param sectionnumber %}}.1: Install OpenShift Client Jenkins Plugin

The **OpenShift Client Jenkins Plugin** plugin adds steps that directly interact with a given OpenShift Platform <https://github.com/jenkinsci/openshift-client-plugin>.


### Install the plugin

Install the **OpenShift Client Jenkins Plugin** to your Jenkins master.

> See lab 9 if you need a guidance.


### Configure the plugin

Configure the OpenShift cluster you want to connect to.

1. Go to `Dashboard` ➡ `Manage Jenkins` ➡ [Configure System](http://localhost:8080/configure)
1. Under **OpenShift Client Plugin** click `Add OpenShift Cluster`
1. For name enter `my-cluster`
1. Insert `API Server URL` (provided by teacher)
1. Leave Credentials unchanged: `-none-`
1. Check `Disable TLS Verify`

The plugin needs the oc cli. Configure an installer for it.

1. Go to `Dashboard` ➡ `Manage Jenkins` ➡ [Global Tool Configuration](http://localhost:8080/configureTools/)
1. Under **OpenShift Client Tools** click `Add OpenShift Client Tools`
1. Under name enter `oc4`
1. Check `Install automatically`
1. Under `Add Installer` select `Extract *.zip/*.tar.gz`
    * Under `Download URL for binary archive` enter:
      * `https://github.com/openshift/okd/releases/download/4.6.0-0.okd-2021-02-14-205305/openshift-client-linux-4.6.0-0.okd-2021-02-14-205305.tar.gz`
1. At the bottom of the page click `Save`


## Task {{% param sectionnumber %}}.2: Test oc tool


Create a new branch named ``lab-18.1`` from branch ``lab-8.1`` and change the contents of the ``Jenkinsfile`` to:

<!--
```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
```
-->

```
{{< highlight groovy "hl_lines=10 13-23" >}}
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
    }
    tools {
        oc 'oc4'
    }
    stages {
        stage('oc test') {
            steps {
                println "PATH: ${PATH}"

                println "OC Version from Shell, must be available:"
                sh "oc version"

                println "which oc"
                sh "which oc"
            }
        }
    }
}
{{< / highlight >}}
```


### Check build log output

Check the build log (Console Output) of the first run of this pipeline.

* Do you see the installation of the oc sli?
* What version is it?


## Task {{% param sectionnumber %}}.3: OpenShift integration

For Jenkins to be able to login into an OpenShift platform and do changes inside a project we need an ServiceAccount.

```YAML
{
  "apiVersion": "v1",
  "kind": "ServiceAccount",
  "metadata": {
    "name": "jenkins-external"
  }
}
```

Create the ressource with the oc tool (`oc create -f ...`) or add it from the OpenShift web GUI (Developer view ➡ `+Add` ➡ `YAML`).

The token of this ServiceAccount is used by Jenkins to login.


### Get login token

You can get the token by oc tool or from the GUI.


#### Get token by oc tool

One-liner to get the login token:

```s
oc serviceaccounts get-token jenkins-external
```


#### Get token by OpenShift web GUI

Click on the `YAML` tab and get the name of the secret holding the token.


```
{{< highlight groovy "hl_lines=2" >}}
secrets:
  - name: jenkins-external-token-x97jl
  - name: jenkins-external-dockercfg-bvfnr
{{< / highlight >}}
```

Find the secret, go to `Project` ➡ `Inventory` ➡ `Secrets` and click on the name of your secret.

Under `Data` ➡ `token` click the *Copy to Clipboard* button.


### Create Jenkins credential with token

Create an credential in Jenkins global scope.

1. Kind: `OpenShift Token for OpenShift Client Plugin`
1. Token: from jenkins-external ServiceAccount (ask teacher)
1. ID: `openshift-jenkins-external`
1. Description: `OpenShift jenkins-external ServiceAccount login token`

> See lab 12 for guidance.


### Project edit rights for Jenkins

The jenkins-external ServiceAccount needs the rights to see and edit the project resources.


#### Add rights by OpenShift web GUI

Go to Administrator view ➡ `User Management` ➡ `Role Bindings`

1. Check `Create Binding`
1. Under `Role Binding` add Name: `jenkins-external-edit`
1. Under `Role` ➡ `Role Name` find and add Name: `edit`
1. Under `Subject` select `Service Account`
1. Find and add select your project under `Subject Namespace` (ask teacher)
1. Enter `jenkins-external` as Subject Name
1. Click `Create` button


#### Add rights by oc tool

One-liner to add edit rights to the service account:

```s
oc policy add-role-to-user edit system:serviceaccount:$(oc project --short):jenkins-externa
```

> If you get errors, replace `$(oc project --short)` with the project name.


## Task {{% param sectionnumber %}}.4: Test OpenShift integration

Create a new branch named ``lab-18.2`` from branch ``lab-18.1`` and add following stage to the ``Jenkinsfile``:


<!--
```groovy
pipeline {
    agent any // with hosted env use agent { label env.JOB_NAME.split('/')[0] }
```
-->

```
{{< highlight groovy "hl_lines=24-41" >}}
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
    }
    tools {
        oc 'oc4'
    }
    stages {
        stage('oc test') {
            steps {
                println "PATH: ${PATH}"

                println "OC Version from Shell, must be available:"
                sh "oc version"

                println "which oc"
                sh "which oc"
            }
        }
        stage('oc login') {
            steps {
                script {
                    openshift.withCluster("my-cluster") {
                        openshift.withCredentials("openshift-jenkins-external") {
                            openshift.withProject("<TEST-PROJECT>") {
                                println "OC Version from Plugin:"
                                println openshift.raw('version').out
                                echo "Hello from project ${openshift.project()} in cluster ${openshift.cluster()}"
                                println openshift.raw('get','project').out
                                println openshift.raw('status').out
                                println openshift.raw('get','pod').out
                            }
                        }
                    }
                }
            }
        }
    }
}
{{< / highlight >}}
```

> Change `<TEST-PROJECT>` to the name of your project (ask teacher)


## Task {{% param sectionnumber %}}.5: Jenkins Pipeline in OpenShift

OpenShift 3.4 supports Jenkins pipelines as build strategy. OpenShift then spins up a Jenkins master as a Pod and runs the pipeline on it.
In this techlab the Jenkins master is already running.

1. Create a file named ``pipeline.yml`` with the following content, replacing ``<myusername>`` with your user name.

    ```yaml
    apiVersion: v1
    kind: BuildConfig
    metadata:
      name: <myusername>-pipeline
    spec:
      runPolicy: Serial
      source:
        type: Git
        git:
          uri: https://github.com/<myusername>/jenkins-techlab
          ref: lab-13.1
      strategy:
        type: JenkinsPipeline
        jenkinsPipelineStrategy:
          jenkinsfilePath: Jenkinsfile
    ```

2. Import it into OpenShift with: ``oc create -f pipeline.yml``

You can now see the pipeline in Jenkins as well as in OpenShift, including a visualization of the various stages.

Check out <https://blog.openshift.com/openshift-3-3-pipelines-deep-dive/> for further infos.
