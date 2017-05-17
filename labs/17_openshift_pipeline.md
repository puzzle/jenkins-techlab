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
