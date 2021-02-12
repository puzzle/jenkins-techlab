#!/bin/bash
export HUGO_VERSION=$(grep "FROM klakegg/hugo" Dockerfile | sed 's/FROM klakegg\/hugo://g' | sed 's/ AS builder//g')
docker run \
  --rm --interactive --entrypoint='' \
  --publish 8080:8080 \
  -v $(pwd):/src \
  klakegg/hugo:${HUGO_VERSION} \
  /src/reveal-slides/build-slides.sh