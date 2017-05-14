Lab 2: First Steps
==================

In this lab we create our first Jenkins pipelines.

Lab 2.1: Create folder
----------------------

Login to the techlab jenkins master with your techlab account.

Create a folder for your techlab projects by clicking "New Item" -> "Folder". Use your username
as the folder name. Click "Ok" and then "Save" on the following screen.

Lab 2.2: Declarative "Hello, World!"
------------------------------------

Create a new Pipeline named "lab-2.2" in your folder. Add the following pipeline definition:

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

Save and run the pipeline.

Notes:

* Declarative pipelines require Jenkins Pipeline 2.5 or later
* ``agent any`` indicates that any of the available executors can be used and allocates a workspace. ``agent`` is the equivalent of ``node`` in scripted pipelines.
* ``agent`` and ``stages`` are mandatory in declarative Pipelines.

Lab 2.3: Scripted "Hello, World!"
---------------------------------

Create a new Pipeline named "lab-2.3" in your folder with the following pipeline definition:

```groovy
node {
    stage('Greeting') {
        echo 'Hello, World!'
    }
}
```

Save and run the pipeline.

Notes:

* Stages are optional but recommended in scripted pipelines
* ``node`` is technically optional in declarative pipelines but required by any steps which depend on a workspace, e.g. ``checkout`` or ``sh``. So any non-trivial pipeline will require it.
