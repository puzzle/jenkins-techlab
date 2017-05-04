Lab 3: Jenkinsfile
==================

Using Jenkinsfiles allows pipelines to be managed as code in SCM. Jenkins has the ability to automatically create Jobs based on Git repositories containing Jenkinsfiles:

* Multibranch: Jenkins automatically manages jobs based on Jenkinsfiles in branches of a single Git repository.
* Organization Folder: Jenkins automatically manages jobs for Jenkinsfiles in a set of Git repositories. (Currently GitHub and Bitbucket), including pull requests and forks.

Lab 3.1: First Jenkinsfile
--------------------------

1. Create a new GitHub repository with a suitable name, e.g. ``jenkins-techlab``.
2. Create a new branch in the repository named ``lab-3.1``
3. Create a file name ``Jenkinsfile`` with the following content in the root directory of the ``lab-3.1`` branch.

    ```groovy
    pipeline {
        agent any

        stages {
            stage('Build') {
                steps {
                    echo 'Building...'
                }
            }
            stage('Test') {
                steps {
                    echo 'Testing...'
                }
            }
            stage('Deploy') {
                steps {
                    echo 'Deploying...'
                }
            }
        }
    }
    ```

4. Create a new multibranch pipeline in your folder named "techlab"
5. Add a Git branch source
6. Set "Project Repository" to the URL of your new GitHub repository (use the https URL for anonymous access)
7. Set the trigger "Periodically if not otherwise run" to "2 minutes"
8. Click "Save"

If everything is configured correctly this will immediately scan your repository, create a job named "lab-3.1" below the multibranch pipeline and start a build of the "lab-3.1" job.

Lab 3.2: Scripted Jenkinsfile
-----------------------------

Multibranch pipelines, like simple pipelines, support declarative and scripted syntax. Create a
new branch "lab-3.2" based on the "lab-3.1" branch in your repository. When Jenkins scans the repository the next time it will create a corresponding job.
Now update the ``Jenkinsfile`` with a scripted version of the pipeline:

```groovy
node {
    echo 'Scripted pipeline'
    stage('Build') {
      echo 'Building...'
    }
    stage('Test') {
        echo 'Testing...'
    }
    stage('Deploy') {
        echo 'Deploying...'
    }
}
```

The multibranch pipeline scan trigger will also trigger builds of any jobs whose ``Jenkinsfile`` changes.

You can only view but not edit the configuration of a job generated from a ``Jenkinsfile``. The ``Jenkinsfile`` is the single source of truth <https://en.wikipedia.org/wiki/Single_source_of_truth> for these jobs. The next lab shows how to configure job properties like log rotation and build triggers in a ``Jenkinsfile``.
