#!/bin/bash

script_dir=`dirname $0`

# create projects
for i in {1..12}
do
   echo "create hannelore$i projects"
   oc new-project hannelore$i-dev
   oc new-project hannelore$i-test
   oc policy add-role-to-user admin hannelore$i -n hannelore$i-dev
done
