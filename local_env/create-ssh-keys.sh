#!/bin/bash

ssh-keygen -t rsa -b 4096 -N "" -f techlab.key -C ""

TECHLAB_PUBLIC_KEY="$(cat techlab.key.pub)"

touch local_env/agent/env_file

echo "JENKINS_AGENT_SSH_PUBKEY=$TECHLAB_PUBLIC_KEY" > local_env/agent/env_file 

mv -f techlab.key local_env/master/agent_connection_key

rm techlab.key.pub
