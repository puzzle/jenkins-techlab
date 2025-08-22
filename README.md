# Jenkins Pipeline Techlab

This technical lab is a hands-on workshop. You learn how to use and write Jenkins pipelines in a continuous delivery perspective.

## Techlab last given

- Before 2023
- last update 07.2025

## Content Sections

The training content resides within the [content](content) directory.

The main part are the labs, which can be found at [content/en/docs](content/en/docs).


## Slides

Slides under reveal-slides will be generated during the build process and be available under `slides/intro`

To generate the slides during the development use:

```bash
./generateslides.sh
```

The slides will be generated in the `public/slides/intro` directory


## Hugo

This site is built using the static page generator [Hugo](https://gohugo.io/).

The page uses the [docsy theme](https://github.com/google/docsy) which is included as a Hugo Module.
Docsy is being enhanced using [docsy-plus](https://github.com/acend/docsy-plus/) as well as
[docsy-acend](https://github.com/acend/docsy-acend/) and [docsy-puzzle](https://github.com/puzzle/docsy-puzzle/)
for brand specific settings.

After cloning the main repo, you need to initialize the Hugo Module like this:

```bash
hugo mod get
```

The default configuration uses the puzzle setup from [config/_default](config/_default/config.toml).
Further, specialized environments can be added in the `config` directory.


### Docsy theme usage

* [Official docsy documentation](https://www.docsy.dev/docs/)
* [Docsy Plus](https://github.com/acend/docsy-plus/)


### Update submodules for theme updates

Run the following command to update all submodules with their newest upstream version:

```bash
hugo mod get -u
```


## Build production image locally


### Docker

Build the image:

```bash
docker build -t puzzle/jenkins-techlab:latest .
```

Run it locally:

```bash
docker run --rm -p 8080:8080 puzzle/jenkins-techlab
```


### Buildah and Podman

Build the image:

```bash
buildah build-using-dockerfile -t puzzle/jenkins-techlab:latest .
```

Run it locally:

```bash
podman run --rm --rmi --publish 8080:8080 localhost/puzzle/jenkins-techlab
```

**Note:** Beware that `--rmi` automatically removes the built image when the container stops, so you either have to rebuild it or remove the parameter from the command.


## How to develop locally

To develop locally we don't want to rebuild the entire container image every time something changed, and it is also important to use the same hugo versions like in production.
We simply mount the working directory into a running container, where hugo is started in the server mode.

```bash
export HUGO_VERSION=$(grep "FROM docker.io/floryn90/hugo" Dockerfile | sed 's/FROM docker.io\/floryn90\/hugo://g' | sed 's/ AS builder//g')
docker run --rm --publish 8080:8080 -v $(pwd):/src docker.io/floryn90/hugo:${HUGO_VERSION} server -p 8080
```

Use the following command to set the hugo environment

```bash
export HUGO_VERSION=$(grep "FROM docker.io/floryn90/hugo" Dockerfile | sed 's/FROM docker.io\/floryn90\/hugo://g' | sed 's/ AS builder//g')
docker run --rm --publish 8080:8080 -v $(pwd):/src docker.io/floryn90/hugo:${HUGO_VERSION} server --environment=<environment> -p 8080
```


## Linting of Markdown content

Markdown files are linted with <https://github.com/DavidAnson/markdownlint>.
Custom rules are in `.markdownlint.json`.
There's a GitHub Action `.github/workflows/markdownlint.yaml` for CI.
For local checks, you can either use Visual Studio Code with the corresponding extension, or the command line like this:

```shell script
npm install
npm run mdlint
```

Npm not installed? no problem

```bash
export HUGO_VERSION=$(grep "FROM docker.io/floryn90/hugo" Dockerfile | sed 's/FROM docker.io\/floryn90\/hugo://g' | sed 's/ AS builder//g')
docker run --rm -v $(pwd):/src docker.io/floryn90/hugo:${HUGO_VERSION}-ci /bin/bash -c "npm install && npm run mdlint"
```

Automatically fix errors if possible:

```bash
npm run mdlint-fix
```


## Github Actions


### Build

The [build action](.github/workflows/build.yaml) is fired on Pull Requests does the following

* builds all PR Versions (Linting and Docker build)
* deploys the built container images to the container registry
* Deploys a PR environment in a k8s test namespace with helm
* Triggers a redeployment
* Comments in the PR where the PR Environments can be found


### PR Cleanup

The [pr-cleanup action](.github/workflows/pr-cleanup.yaml) is fired when Pull Requests are closed and does the following

* Uninstalls PR Helm Release


### Push Main

The [push main action](.github/workflows/push-main.yaml) is fired when a commit is pushed to the main branch (eg. a PR is merged) and does the following, it's very similar to the Build Action

* builds main Versions (Linting and Docker build)
* deploys the built container images to the container registry
* Deploys the main Version on k8s using helm
* Triggers a redeployment


## Helm

Manually deploy the training Release using the following command:

```bash
helm install --repo https://acend.github.io/helm-charts/  <release> acend-training-chart --values helm-chart/values.yaml -n <namespace>
```

For debugging purposes use the `--dry-run` parameter

```bash
helm install --dry-run --repo https://acend.github.io/helm-charts/  <release> acend-training-chart --values helm-chart/values.yaml -n <namespace>
```


## Contributions

If you find errors, bugs or missing information please help us improve and have a look at the [Contribution Guide](CONTRIBUTING.md).
