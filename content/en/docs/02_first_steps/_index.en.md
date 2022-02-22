---
title: "2. First Steps"
weight: 2
sectionnumber: 2
---

In this lab we create our first Jenkins pipeline.
Jenkins has the ability to automatically create Jobs based on Git repositories containing a ``Jenkinsfile``:

* Multibranch: Jenkins automatically manages jobs based on Jenkinsfiles in branches of a single Git repository.
* Organization Folder: Jenkins automatically manages jobs for Jenkinsfiles in a set of Git repositories. (Currently GitHub and Bitbucket), including pull requests and forks.

In these labs we use the former method, so that each participant can configure its labs independently.
A ``Jenkinsfile`` provides a single source of truth for a build job <https://en.wikipedia.org/wiki/Single_source_of_truth>.


## Task {{% param sectionnumber %}}.1: Declarative "Hello, World!"

1. Create a new GitHub repository with a suitable name, e.g. ``jenkins-techlab-exercises``.
1. Create a new branch in the repository named ``lab-2.1``
1. Create a file named ``Jenkinsfile`` with the following content in the root directory of the ``lab-2.1`` branch.

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

1. On Jenkins, create a new "Multibranch Pipeline" item named ``techlab`` in your previously created folder
1. Add a Git branch source (not Github, because then you need credentials)
1. Set "Project Repository" to the URL of your new GitHub repository (use the https URL for anonymous access)
1. Set the trigger "Periodically if not otherwise run" to "2 minutes"
1. Click **Save**

If everything is configured correctly this will

* immediately scan your repository,
* create a job named "lab-2.1" below the multibranch pipeline
* and start a build of the "lab-2.1" job.

The multibranch pipeline scan trigger will also trigger builds of any jobs whose ``Jenkinsfile`` changes.

You can only view but not edit the configuration of a job generated from a ``Jenkinsfile``. The ``Jenkinsfile`` is the [single source of truth](https://en.wikipedia.org/wiki/Single_source_of_truth) for these jobs, the only thing that is configured directly in Jenkins, is how to access the repositories. The next lab shows how to configure job properties like log rotation and build triggers in a ``Jenkinsfile``.

Note:

* Declarative pipelines require Jenkins Pipeline 2.5 or later
* ``agent any`` indicates that any of the available executors can be used and allocates a workspace. ``agent`` is the equivalent of ``node`` in scripted pipelines.
* ``agent`` and ``stages`` are mandatory in declarative Pipelines.


## Task {{% param sectionnumber %}}.2: Scripted "Hello, World!"

``Jenkinsfile`` also supports a scripted syntax. This can be considered a legacy feature and it is recommended to use the declarative syntax.

With the scripted syntax the above example would look like this:

```groovy
node {
    stage('Greeting') {
        echo 'Hello, World!'
    }
}
```

If you are interested in the scripted syntax (or maybe have to maintain older projects) you can find scripted versions of most labs under [Additional - scripted](../20_additional/scripted).

Note:

* Stages are optional but recommended in scripted pipelines
* ``node`` is technically optional in scripted pipelines but required by any steps which depend on a workspace, e.g. ``checkout`` or ``sh``. So any non-trivial pipeline will require it.
