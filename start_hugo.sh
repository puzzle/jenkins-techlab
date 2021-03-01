#!/bin/bash
export HUGO_VERSION=$(grep "FROM klakegg/hugo" Dockerfile | sed 's/FROM klakegg\/hugo://g' | sed 's/ AS builder//g')
docker run \
  --rm --interactive \
  --publish 8081:8081 \
  -v $(pwd):/src \
  klakegg/hugo:${HUGO_VERSION} \
  server -p 8081 --bind 0.0.0.0
