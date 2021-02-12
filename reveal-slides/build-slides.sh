#!/bin/bash
cp -a /src/reveal-slides /tmp/reveal-slides 
cd /tmp/reveal-slides 
npm install 
npm run-script static 
mv images out && mv theme out
mkdir -p /src/public/slides/intro
mv /tmp/reveal-slides/out/* /src/public/slides/intro