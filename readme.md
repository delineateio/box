<p align="center">
  <img alt="delineate.io" src="https://github.com/delineateio/.github/blob/master/assets/logo.png?raw=true" height="75" />
  <h2 align="center">delineate.io</h2>
  <p align="center">portray or describe (something) precisely.</p>
</p>

# Box

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg)](https://github.com/delineateio/box/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22+)

## Purpose

The purpose of **box** is to provide a general purpose development environment with a pre-installed set of very useful development tools.  Specifically `box` aims to automate all the fiddly install, config and integration between commonly used tools to make engineers lives easier!

This project provides a `vagrant` box that can be used as the base box for project boxes which add further project specific customisations.  The `box` is published to Vagrant Cloud [here](https://app.vagrantup.com/delineateio/boxes/box).

## Contributing

Contributions to this project are welcome!

* [Contribution Guidelines](https://github.com/delineateio/.github/blob/master/CONTRIBUTING.md)
* [Code of Conduct](https://github.com/delineateio/.github/blob/master/CODE_OF_CONDUCT.md)

Please note that [git commit signing](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work) is required to contribute to this project.

## Local Requirements

The solution relies heavily on [Hashicorp Vagrant](https://www.vagrantup.com/) and [Redhat Ansible](https://www.ansible.com/). The base box is a [Ubuntu 18.04](https://releases.ubuntu.com/18.04/) machine from the [Chef Bento Project](https://github.com/chef/bento).

 On MacOS the mandatory tools can be installed using `brew`.

```shell
# Installs Ansible, VirtualBox & Vagrant
brew install --cask virtualbox vagrant
```

For additional information including alternative installation methods please review the official documentation:

* [Oracle VirtualBox docs](https://www.virtualbox.org/wiki/Documentation)
* [Hashicorp Vagrant docs](https://www.vagrantup.com/docs)

Optionally Vagrant Manager can be installed on MacOS to provide access from the menu bar.  For more information on Vagrant Manager see [here](https://www.vagrantmanager.com/).

```shell
# optionally install Vagrant Manager
brew install --cask vagrant-manager
```

![vagrant manager](./assets/manager.png)

## Packaging

To package the `box` for release on [Vagrant Cloud](https://app.vagrantup.com/) a script has been provided.  This script can be found `./scripts/package.sh`, this script does a couple of things:

1. Builds the box from scratch to ensure it's box fresh
2. Runs minimisation scripts during`vagrant up` to clean and minimise the box
3. Creates an `md5` checksum so that this can be published with the box

> The scripts are called from within the `vagrantfile` have been copied and modified from the [Chef Bento](https://github.com/chef/bento) project.  These scripts make a major difference to the file size reducing the unmodified box by two thirds!

## Project Usage

### Project Vagrantfile

The VM box created by this project is hosted on Hashicorp Vagrant Cloud [here](https://app.vagrantup.com/delineateio/boxes/box).  Consult the `vagrant` documentation for more details, below shows the minimum configuration required in a `vagrantfile` to use the box.

```ruby
Vagrant.configure("2") do |config|

  config.vm.box = "delineateio/box"
  config.vm.box_version = "1.1.0"

  # http(s) traffic into the box
  config.vm.network "forwarded_port", guest: 80, host: 80, protocol: "tcp"
  config.vm.network "forwarded_port", guest: 443, host: 443, protocol: "tcp"

  # postgres
  config.vm.network "forwarded_port", guest: 5432, host: 5432, protocol: "tcp"

end
```

### Project Configuration

To configure specific tools overwrite the `~/.box/config.yml` file with the required settings.  To skip configuration of a tool simply omit the config key.

```yaml
gcloud:
  account:    # gcp service account email
  key:        # gcp service account json
  project:    # gcp project
  region:     # gcp region
  zone:       # gcp region
  registries: # gcr registry (e.g. eu.gcr.io)
  cluster:    # gke cluster name
ssh:
  private:    # private key
  public:     # public key
git:
  name:       # git name
  email:      # git email
tokens:
  circleci:   # circleci token
  do:         # digital ocean token
  github:     # github token
  snyk:       # snyk token
golang:       # additional golang versions
  -
nodejs:       # additional node versions
  -
python:       # additional python versions
  -
terraform:    # additional terraform versions
  -
use:
  golang:     # golang version to use
  nodejs:     # nodejs version to use
  terraform:  # terraform version to use
  python:     # python version to use
apt:
  packages:
    -         # additional apt packages
deb:
  packages:   # additional deb packages
    - name:
      url:
archive:
  packages:   # additional archive packages
    - name:
      src:
      dest:
url:
  packages:   # additional url packages
    -
npm:
  packages:   # additional npm packages
    - name:
      version:
pip:
  packages:   # additional pip packages
    -
```

If `git` signing is required then a a `gpg` key file should be copied to `~/.box/gpg.key`.  One way of copying the files into the box is to use file provisioners from the project `vagrantfile`.

```ruby
# copy the config file
config.vm.provision "file", source: "./gpg.key", destination: "$HOME/.box/gpg.key"
# copy the gpg key
config.vm.provision "file", source: "./config.yml", destination: "$HOME/.box/config.yml"
```

> Once the configuration file is provided or updated then then `box` command can be run inside the VM to reconfigure the box.  **This does not get run automatically, so needs to be run once the VM has been first provisioned.**

### Running Box

In the directory where the `vagrantfile` is located, the command `vagrant up --provider virtualbox` can be run to create the VM.

Note that specific port forwarding should be configured to access tools from the host (e.g. `postgres`, `octant`).  It maybe necessary to explicitly set different host ports to get stable port numbers.`)

```ruby
config.vm.network "forwarded_port", guest: 80, host: 80, protocol: "tcp" # http
config.vm.network "forwarded_port", guest: 443, host: 443, protocol: "tcp" # https
config.vm.network "forwarded_port", guest: 5432, host: 5432, protocol: "tcp" # postgres
```

### HTTPS Proxy

Installed within the VM is a [caddy](https://caddyserver.com/) reverse proxy which is configured to route traffic to services hosted within the VM.  This is why in the example above ports `80` and `443` are forwarded.

The proxy is used a Let's Encrypt provisioned TLS certificate from Cloudflare.  To enable traffic from the host a entries must be provided in `/etc/hosts`

| IP | Action | Service |
| --- | ----------- | -----------|
| 127.0.0.1 | [https://clusters.getbox.io](https://clusters.getbox.io) | octant |

> Note that to access these tools from the host then entries need to be added to the `/etc/hosts` file accordingly.

## Pre-configured Tools

The following tools and languages are automatically installed using `ansible` as part of the provisioning and configuration process

> There are some further details provided below on elements of the configuration of some of the most important packaged tools.

### General Tools

* [bat](https://github.com/sharkdp/bat) - A `cat` clone with syntax highlighting and Git integration
* [circleci](https://github.com/CircleCI-Public/circleci-cli) - CLI for working with [CircleCI](https://circleci.com/)
* [gh](https://cli.github.com/) - Work with issues, pull requests, checks, releases from the terminal
* [pre-commit](https://pre-commit.com/) - A framework for managing and maintaining multi-language pre-commit hooks
* [screen](https://www.gnu.org/software/screen/manual/screen.html) - full-screen window manager that multiplexes a physical terminal between several processes
* [shellcheck](https://github.com/koalaman/shellcheck) - Shell script static analysis tool for instant feedback

### Security Tools

* [detect-secrets](https://github.com/Yelp/detect-secrets) - Detecting secrets within enterprise code bases before commit
* [snyk](https://github.com/snyk/snyk) - Find, fix and monitor known vulnerabilities
* [trivy](https://github.com/aquasecurity/trivy) - Simple and comprehensive vulnerability scanner for containers and other artifacts

### APIs

* [hey](https://github.com/rakyll/hey) - HTTP load testing with concurrency level and printing stats
* [httpie](https://httpie.io/) - User-friendly command line HTTP client for the API era
* [jq](https://stedolan.github.io/jq/) - Slice, filter, map and transform JSON data
* [stts](https://www.npmjs.com/package/stts) - Quick, completely offline reference for HTTP status codes

### Serverless, Containers & k8s

* [docker](https://www.docker.com/) - Solution for defining and using containers
* [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) - Controls the Kubernetes cluster manager
* [octant](https://octant.dev/) - Developer-centric web interface for Kubernetes
* [pack](https://buildpacks.io) - transform application source code into images that can run on any cloud
* [serverless](https://www.serverless.com/) - Zero-friction serverless development to easily build apps that auto-scale on low cost, next-gen cloud infrastructure
* [skaffold](https://skaffold.dev/) - Workflow for building, pushing and deploying your k8s applications
* [st](https://github.com/GoogleContainerTools/container-structure-test) - Powerful framework to validate the structure of a container images

### Databases

* [psql](http://postgresguide.com/utilities/psql.html) - Interactive terminal for working with Postgres

### Cloud & Infrastructure Tools

* [cloudquery](https://cloudquery.io/) - Transforms your cloud infrastructure into queryable SQL tables or Graphs for easy monitoring, governance and security
* [doctl](https://github.com/digitalocean/doctl) - Command-line interface (CLI) for DigitalOcean
* [gcloud](https://cloud.google.com/sdk/docs/install) - Command-line interface (CLI) for Google Cloud Platform
* [inspec](https://community.chef.io/tools/chef-inspec/) - Turn compliance, security, and other policies into automated tests
* [osquery](https://osquery.io/) - SQL powered OS instrumentation, monitoring, and analytics framework
* [packer](https://www.packer.io/) - Automates the creation of any type of machine image
* [tfenv](https://github.com/tfutils/tfenv) - Provides an interface to manage Terraform versions

### Network Tools

* [iotop](https://github.com/analogue/iotop) - shows process I/O usage and issues
* [mtr](https://github.com/traviscross/mtr/) - Investigates the network between the host and destination host
* [nmap](https://nmap.org/docs.html) - Utility for network discovery and security auditing

> These tools are in addition to ths standard tools that are available in the base VM (`ping`, `netstat`, `nslookup` etc)

### Inspection Tools

* [neofetch](https://github.com/dylanaraps/neofetch) - Displays information about your operating system, software and hardware

## Installed Languages

* [clojure](https://clojure.org/) - Robust, practical, and fast programming language with a set of useful features
* [gvm](https://github.com/moovweb/gvm) - Provides an interface to manage Go versions
* [nvm](https://github.com/nvm-sh/nvm) - Lets you easily switch between multiple versions of Node.js
* [pyenv](https://github.com/pyenv/pyenv) - Lets you easily switch between multiple versions of Python
* [ruby](https://www.ruby-lang.org/en/) - A dynamic programming language with a focus on simplicity and productivity
* [rust](https://www.rust-lang.org/) - Language empowering everyone to build reliable and efficient software
* [scala](https://www.scala-lang.org/) - Object-oriented and functional programming in one concise, high-level language

## Key Configurations

### Starship

The `starship` prompt has been installed and configured with simplified configuration from the defaults.  To review the configuration run `bat $HOME/.config/starship.toml`.

### Git Aliases

A number of convenient `git` aliases are provided:

* `git initial` enables rebasing to the root to help get a clean initial commit
* `git last` provides a detailed view of the last commit
* `git pretty` provides a concise log of the commits
* `git root` shows the absolute path of the projects root directory

### GPG Commit Signing

`git` is pre-configured by default to use `gpg` signing so commits are verified.  To learn more read the `github` documentation on [signing commits](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/signing-commits).  At present the `gpg` key found at `$HOME/gpg_public` needs to be manually added to `github`.

The requires the addition of the `~/.box/gpg.key` as mentioned earlier in the documentation.

### Postgres

A `docker` container for `postgres:11.6` is deployed as this is the most common database platform used for development.  The container exposes postgres on the standard `5432` port.  To simplify connectivity a `.pgpass` file has been configured to ease connectivity when using `psql`.

```shell
# connects to the local postgres instance
psql -h localhost -U postgres
```

> To access the `postgres` container from the host when developing using an IDE on the host port forwarding must be enabled.  It maybe necessary to use a non-standard port to avoid port clashes and provide a predictable port.

```ruby
Vagrant.configure("2") do |config|
  # access to postgres on default port
  config.vm.network "forwarded_port", guest: 5432, host: 5432, protocol: "tcp"
end
```

### Docker

In addition to help with housekeeping a `docker prune -f` job is scheduled using `cron`.

### CloudQuery

If a `gcloud.key` is provided in `~/.box/config.yml` the `cloudquery` which fetch and cache the data locally into postgres so that cloud resource data can be queried.  For more details see the `cloudquery` documentation [here](https://docs.cloudquery.io/).
