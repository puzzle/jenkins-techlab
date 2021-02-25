#!/bin/bash

script_dir=`dirname $0`

# create projects
for i in {1..12}
do
   echo "Infos for hannelore$i (Password: APPUiO$i@2020)"
   oc project hannelore$i-dev
   echo ""
   echo "--- hannelore$i-dev login token start ---"
   oc serviceaccounts get-token jenkins-external
   echo "--- hannelore$i-dev login token end ---"
   echo ""
   oc project hannelore$i-test
   echo ""
   echo "--- hannelore$i-test login token start ---"
   oc serviceaccounts get-token jenkins-external
   echo "--- hannelore$i-test login token end ---"
   echo ""
   echo ""
   echo ""
done
