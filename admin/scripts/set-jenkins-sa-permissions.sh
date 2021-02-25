#!/bin/bash

script_dir=`dirname $0`

# create projects
for i in {1..12}
do
   echo "create hannelore$i sa permissions"
   oc policy add-role-to-user edit system:serviceaccount:hannelore$i-dev:jenkins-external -n hannelore$i-dev
   oc policy add-role-to-user edit system:serviceaccount:hannelore$i-test:jenkins-external -n hannelore$i-test
done
