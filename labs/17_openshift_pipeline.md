Lab 8: OpenShift Integration
============================

OpenShfit integrates quite nicely with the jenkins pipelines.

Lab 8.1: calling OpenShift within the pipelines
-----------------------------------------------

The following plugin adds steps that directly interact with a given OpenShift Platform  https://github.com/openshift/jenkins-plugin



Lab 8.2: Jenkins Pipeline in OpenShift
--------------------------------------

OpenShift 3.4 supports jenkins pipelines as build strategy. OpenShift then spins up a jenkins as a Pod and runs the pipeline on it.

A build config then looks like this:

```yaml
apiVersion: v1
kind: BuildConfig
metadata:
  name: promote-pipeline
spec:
  runPolicy: Serial
  source:
    type: Git
    git:
      uri: https://github.com:dtschan/jenkins-techlab-openshift
      ref: master    
  strategy:
    type: JenkinsPipeline
    jenkinsPipelineStrategy:
      jenkinsfilePath: Jenkinsfile
```

Check out https://blog.openshift.com/openshift-3-3-pipelines-deep-dive/ for further infos.
