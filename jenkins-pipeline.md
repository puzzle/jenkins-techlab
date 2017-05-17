---
title: Jenkins Pipelines
---

<!--section -->
# Jenkins Pipeline - Pipeline as Code

<!-- .slide: class="master02" -->

---

## Agenda

* Introduction into Jenkins Pipeline and CI/CD, 60'
* Setup Lab Environment, 30'
* Hands-on Techlab, Rest of the Day
* Recap and Feedback, 15'

---

## Objectives

* Learn about jenkins best practices
* Learn how to write Pipelines
* Learn about the different kinds of implementations
* Get a basic toolset on how to implement the basic use cases

---

## Jenkins Basic Overview

![Jenkins Overview](images/Jenkins_overview.png)

---

## Jenkins Basic Info

* Consists of Masters
  * Stateful
  * Management of Jobs, Credentials, ...
  * Plugins (always run on master)
* and Slaves
  * Actually run the jobs
  * Stateless

---

## Scaling a Build Infrastructure

* jobs = number of developers * 3.333
* masters = number of jobs/500
* executors = number of jobs * 0.03

Source: https://jenkins.io/doc/book/architecting-for-scale/

---

## Why a CI Server?


---

![Fist](images/fist_by_jnatoli.jpg)

Source: http://jnatoli.deviantart.com/

---

## Continuous Integration

* code in scm
* check-in and push at least daily
* automated compiling, testing, integrating and building
* reporting and code analysis
* deploy to integration environment

---

## Continuous Delivery

“CONTINUOUS DELIVERY IS THE ABILITY TO GET CHANGES OF ALL TYPES—INCLUDING NEW FEATURES, CONFIGURATION CHANGES, BUG FIXES AND EXPERIMENTS—INTO PRODUCTION,OR INTO THE HANDS OF USERS, SAFELY AND QUICKLY IN A SUSTAINABLE WAY.”

-Jez Humble, continuousdelivery.com

---

## Continuous Delivery

“CONTINUOUS DELIVERY IS THE ABILITY TO GET CHANGES OF **ALL TYPES**—INCLUDING NEW FEATURES, CONFIGURATION CHANGES, BUG FIXES AND EXPERIMENTS—INTO PRODUCTION,OR **INTO THE HANDS OF USERS, SAFELY AND QUICKLY IN A SUSTAINABLE WAY.**”

-Jez Humble, continuousdelivery.com

---

## Continuous Delivery Pipeline

![Continuous Delivery Pipeline](images/ContinuousDeliveryPipeline.png)

---

## Continuous Delivery != Continuous Deployment

![Continuous Delivery Not Continuous Deployment](images/ContinuousDeliveryNotDeployment.png)

---

## Why should we use Pipelines

* Developer Experience
* Self contained
* Fully automated and documented
* Reusable

---

## Pipeline Advantages

* Can be reviewed, forked, iterated upon and audited
* Running pipelines survive master restart
* Can stop and wait for human input
* Support complex CI/CD requirements
* DSL can be extended through shared libraries

---

## Declarative vs Scripted (imperative)

* Declarative: Validation => better error reporting
* Declarative: Better GUI support (Blue Ocean)
* Imperative: mostly used until now

---

## Declarative

```
pipeline {
    agent any
	options { ... }

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
	}
}
```

---

## Scripted

```
node {
    echo 'Scripted pipeline'
    stage('Build') {
      echo 'Building...'
    }
}
```

---

## Groovy Syntax Limitations

* pipelines must survive restart of the jenkins
* scripts mus serialize data back to the master
* not fully supported
```
collection.each { item -> /* perform operation */ }
```

---

## Tools

* Jobs require different build tools
* to keep slaves stateless, tools are installed dynamically during job execution
* Jenkins provides Custom Tools concept

---

## Tools @ Puzzle

* Seeder Job that manages custom tools
* all custom tools script are managed in git
* custom tools check if they already exist (performance)

---

## Best Practices

keep everything you need to build, deploy, test, & release in version control 

---

## Best Practices

* use folders
* keep the slave stateless
* archive artifacts
* reuse functionalities in shared libraries

---

## Best Practices Folders Plugin

How to organize pipelines @ puzzle

```
[Customer]-[project]

hit-hitobito
pitc-appuio
```

---

## Debugging a Pipeline

Use the replay function of a pipeline

![Jenkins Overview](images/Jenkins_replay.png)

---

## Debugging a Pipeline

Use the replay function of a pipeline

![Jenkins Overview](images/Jenkins_replay2.png)

---

## Snippet Generator 

![Jenkins Overview](images/Jenkins_snippet_generator.png)

---

## Snippet Generator 

![Jenkins Overview](images/Jenkins_snippet_generator2.png)

---

## Glossary

| Term | Description |
|---|---|
| Pipeline  | A user-defined model of a continuous delivery pipeline  |
| Build  | Result of a single execution of a Project  |
| Agent  | An agent is typically a machine, or container, which connects to a Jenkins master and executes tasks when directed by the master.  |
| Node  | A machine which is part of the Jenkins environment and capable of executing Pipelines or Projects.  |
| Job  | A deprecated term, synonymous with Project.  |
| Stage  | the phases of a pipeline are called stages  |
| Step  | A single task; fundamentally steps tell Jenkins what to do inside of a Pipeline or Project.  |



---

## Puzzle Jenkins Environment

* 1 master
* 1 main slave
* OpenShift docker slaves on demand

---

## OpenShift Integration (1/2)

* currently Kubernetes plugin
* custom slaves build with its own pipeline
* project specific Slaves

---

## OpenShift Integration (2/2)

prior to 1.0.14 (impl. of SimpleBuildStep)
```
step([$class: 'OpenShiftBuilder', apiURL: .....

```

after 1.0.14

```
def builder = openshiftBuild buildConfig: 'frontend'
```

---

## Techlab Environment

* 1 master deployed on OpenShift techlab env
* every participant its own slave locally

---

## How the Techlab Works

* Guided, hands-on Workshop
* Docs are on github
* please help us to improve the techlab

---

## Resources

* Jekins Book: <https://jenkins.io/doc/book/>
* Examples <https://jenkins.io/doc/pipeline/examples/>
* OpenShift Examples <https://github.com/openshift/origin/tree/master/examples/jenkins/pipeline>

---

## Let's Start 

<https://github.com/puzzle/jenkins-techlab>

---
