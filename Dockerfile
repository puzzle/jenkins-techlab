FROM klakegg/hugo:0.88.0-ext-ubuntu AS builder

ARG TRAINING_HUGO_ENV=default

COPY . /src

RUN hugo --environment ${TRAINING_HUGO_ENV} --minify

RUN /src/reveal-slides/build-slides.sh

FROM nginxinc/nginx-unprivileged:1.21-alpine

EXPOSE 8080

COPY --from=builder /src/public /usr/share/nginx/html
