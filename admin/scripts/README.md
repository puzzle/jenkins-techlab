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

1. Give rights to ServiceAccount jenkins-external:

  ```s
  ./admin/scripts/set-jenkins-sa-permissions.sh
  ```

1. Create user output to give to attendees:

  ```s
  ./admin/scripts/create-user-output.sh
  ```
