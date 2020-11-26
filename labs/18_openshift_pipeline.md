Lab 17: OpenShift Integration
============================

OpenShift integrates quite nicely with the Jenkins pipelines.

Lab 17.1: calling OpenShift within the pipelines
-----------------------------------------------

The following plugin adds steps that directly interact with a given OpenShift Platform  https://github.com/openshift/jenkins-plugin


Lab 17.2: Jenkins Pipeline in OpenShift
--------------------------------------

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

Check out https://blog.openshift.com/openshift-3-3-pipelines-deep-dive/ for further infos.

---

**End of Lab 17**

<p width="100px" align="right"><a href="19_write_migrate_your_own_projects.md">Write / Migrate your own Projects →</a></p>

[← back to overview](../README.md)
