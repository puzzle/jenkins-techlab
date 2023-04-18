FROM klakegg/hugo:0.107.0-ext-ubuntu AS builder

ARG TRAINING_HUGO_ENV=default

COPY . /src

RUN hugo --environment ${TRAINING_HUGO_ENV} --minify

RUN /src/reveal-slides/build-slides.sh

FROM ubuntu:jammy AS wkhtmltopdf
RUN apt-get update \
    && apt-get install -y curl \
    && curl -L https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb --output wkhtmltox_0.12.6.1-2.jammy_amd64.deb \
    && ls -la \
    && apt-get install -y /wkhtmltox_0.12.6.1-2.jammy_amd64.deb \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /wkhtmltox_0.12.6.1-2.jammy_amd64.deb

COPY --from=builder /src/public /

RUN wkhtmltopdf --outline-depth 4 --enable-internal-links --enable-local-file-access  ./pdf/index.html /pdf.pdf

FROM nginxinc/nginx-unprivileged:1.24-alpine

LABEL maintainer puzzle.ch
LABEL org.opencontainers.image.title "puzzle.ch's Jenkins Techlab"
LABEL org.opencontainers.image.description "Container with puzzle.ch's Jenkins Techlab content"
LABEL org.opencontainers.image.authors puzzle.ch
LABEL org.opencontainers.image.source https://github.com/puzzle/jenkins-techlab/
LABEL org.opencontainers.image.licenses CC-BY-SA-4.0

EXPOSE 8080

COPY --from=builder /src/public /usr/share/nginx/html
COPY --from=wkhtmltopdf /pdf.pdf /usr/share/nginx/html/pdf/pdf.pdf
