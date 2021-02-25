# admin scripts


## OpenShift lab

Prepare projects on techlab cluster. Run scripts as cluster admin.

1. Create projects and give rights to users:

  ```s
  ./admin/scripts/create-projects.sh
  ```

1. Create ServiceAccount jenkins-external:

  ```s
  ./admin/scripts/create-jenkins-sa.sh
  ```

