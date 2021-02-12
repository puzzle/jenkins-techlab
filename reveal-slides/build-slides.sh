#!/bin/bash
cp -a /src/reveal-slides /tmp/reveal-slides 
cd /tmp/reveal-slides 
npm install 
npm run-script static 
mv theme/*.svg out/_assets/theme/
mkdir -p /src/public/slides/intro
mv /tmp/reveal-slides/out/* /src/public/slides/intro