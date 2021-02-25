#!/bin/bash

script_dir=`dirname $0`

# create projects
for i in {1..12} do
   echo "create hannelore$i jenkins sa"
   oc apply -f $script_dir/service-account.yaml -n hannelore$i-dev
   oc apply -f $script_dir/service-account.yaml -n hannelore$i-test
done
