#!/bin/bash

ssh-keygen -t rsa -N "" -f techlab.key -C "jenkins@techlab"

export TECHLAB_PRIVATE_KEY=$(cat techlab.key)
export TECHLAB_PUBLIC_KEY=$(cat techlab.key.pub)

rm techlab.key techlab.key.pub
