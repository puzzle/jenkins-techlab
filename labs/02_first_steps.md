Lab 2: First Steps
==================

In this lab we create our first Jenkins pipelines.
Jenkins has the ability to automatically create Jobs based on Git repositories containing a ``Jenkinsfile``:

* Multibranch: Jenkins automatically manages jobs based on Jenkinsfiles in branches of a single Git repository.
* Organization Folder: Jenkins automatically manages jobs for Jenkinsfiles in a set of Git repositories. (Currently GitHub and Bitbucket), including pull requests and forks.

In these labs we use the former method so that each participant can configure its labs independently.
A ``Jenkinsfile`` provides a single source of truth for a build job <https://en.wikipedia.org/wiki/Single_source_of_truth>.

Lab 2.1: Declarative "Hello, World!"
------------------------------------

1. Create a new GitHub repository with a suitable name, e.g. ``jenkins-techlab``.
2. Create a new branch in the repository named ``lab-2.1``
3. Create a file named ``Jenkinsfile`` with the following content in the root directory of the ``lab-2.1`` branch.

```groovy
pipeline {
    agent any
    stages {
        stage('Greeting') {
            steps {
                echo 'Hello, World!'
            }
        }
    }
}
```


4. On Jenkins, create a new "Multibranch Pipeline" item named ``techlab`` in your previously created folder
5. Add a Git branch source (not Github, because then you need credentials)
6. Set "Project Repository" to the URL of your new GitHub repository (use the https URL for anonymous access)
7. Set the trigger "Periodically if not otherwise run" to "2 minutes"
8. Click **Save**

If everything is configured correctly this will immediately scan your repository, create a job named "lab-2.1" below the multibranch pipeline and start a build of the "lab-2.1" job.

Note:
* Declarative pipelines require Jenkins Pipeline 2.5 or later
* ``agent any`` indicates that any of the available executors can be used and allocates a workspace. ``agent`` is the equivalent of ``node`` in scripted pipelines.
* ``agent`` and ``stages`` are mandatory in declarative Pipelines.

Lab 2.2: Scripted "Hello, World!"
---------------------------------

``Jenkinsfile`` supports declarative and scripted syntax. Create a
new branch ``lab-2.2`` based on the ``lab-2.1`` branch in your repository. When Jenkins scans the repository the next time it will create a corresponding job.
Now replace the ``Jenkinsfile`` with a scripted version of the pipeline:

```groovy
node {
    stage('Greeting') {
        echo 'Hello, World!'
    }
}
```

The multibranch pipeline scan trigger will also trigger builds of any jobs whose ``Jenkinsfile`` changes.

You can only view but not edit the configuration of a job generated from a ``Jenkinsfile``. The ``Jenkinsfile`` is the single source of truth <https://en.wikipedia.org/wiki/Single_source_of_truth> for these jobs, the only thing that is configured directly in Jenkins is how to access the repositories. The next lab shows how to configure job properties like log rotation and build triggers in a ``Jenkinsfile``.

Note:
* Stages are optional but recommended in scripted pipelines
* ``node`` is technically optional in declarative pipelines but required by any steps which depend on a workspace, e.g. ``checkout`` or ``sh``. So any non-trivial pipeline will require it.

---

**End of Lab 2**

<p width="100px" align="right"><a href="03_build_options.md">Build Options/Properties →</a></p>

[← back to overview](../README.md)
