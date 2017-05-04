<!--section -->
# Jenkins Pipeline - Pipeline as Code

<!-- .slide: class="master02" -->

---

## Agenda

* Jenkinsfile Intro
  * Advantages
  * Imperative
  * Declarative <https://jenkins.io/doc/book/pipeline/syntax/>
  * Best Practices
    * Folders
    * Slaves stateless
  * Jenkins Book
  * Examples
    * <https://jenkins.io/doc/pipeline/examples/>
    * <https://github.com/openshift/origin/tree/master/examples/jenkins/pipeline>

* global defaults, e.g. logrotate
https://jenkins.io/blog/2017/02/15/declarative-notifications/

https://www.cloudbees.com/sites/default/files/2016-jenkins-world-introducing_a_new_way_to_define_jenkins_pipelines_1.pdf

* Setup
* Hello Pipeline
* Stages, Locks, Milestones
* Build properties
   * log rotate
   * scm trigger
   * cron trigger
* Artefact archiving/stashing
* Credentials
  * ssh-agent
  * with_credentials
* Umgebungsvariabeln
* Build Tools
  * tools()
  * Automatisierung Puzzle
* Snippet Generator
* Error handling
* Quoting/Escaping
* Notification
  * mail
  * rocketchat
  * swoa committer only
* Debugging
   * replay
   * https://jenkins.io/doc/book/pipeline/development/
   * ...?
* Shared Libraries
* Multibranch
* OpenShift 3 Integration
  * Both plugins
* OpenShift Image Triggers
* OpenShift Slaves
* Image Promotion
* Blue Ocean


---

## Pipeline Advantages

* Can be reviewed, forked, iterated upon and audited
* Running pipelines survive master restart
* Can stop and wait for human input
* Support complex CI/CD requirements
* DSL can be extended through shared libraries

----

## Declarative vs Scripted

* Declarative: Validation => better error reporting
* Declarative: Better GUI support (Blue Ocean)

----
