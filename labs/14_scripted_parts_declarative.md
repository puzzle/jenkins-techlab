Lab 14: Scripted Parts in Declarative Pipelines
===============================================

In some rare cases the declarative pipelines and shared libraries might not be enough to implement a certain functionality.
There is an actual possibility to integrate scripted elements into declarative pipelines.

In this lab we are going to show you how these elements look like and how they are used.

**Note:** Keep in mind, when ever such a scripted part is not trivial and simple, you should consider in extracting the functionality
into a shared library, which can easily be tested, reused and keeps the orignal pipeline as declarative as possible.

Lab 14.1: Scripts in Declarative Pipelines
------------------------------------------

Simply adding Groovy code in the declarative pipeline will break the execution. To run custom scripts within the pipeline the script must be surrounded by the ``script`` directive
as the following example shows

```groovy
pipeline {
	agent any
	stages {
		stage('script') {
			steps {
				script {
					def pipelineType = 'declarative'
					echo "yeah we executed a script within the ${pipelineType} pipeline"
				}
			}
		}
	}
}
```
