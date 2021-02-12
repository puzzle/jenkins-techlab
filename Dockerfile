FROM klakegg/hugo:0.80.0-ext-ubuntu AS builder

ARG HUGO_ENV=default

COPY . /src

RUN hugo --environment ${HUGO_ENV} --minify

RUN cd reveal-slides && npm install && npm run-script static && mv theme out && mv images out

FROM nginxinc/nginx-unprivileged:alpine

EXPOSE 8080

COPY --from=builder /src/public /usr/share/nginx/html
COPY --from=builder /src/reveal-slides/out /usr/share/nginx/html/slides/intro
