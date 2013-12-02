###NOTE: I gave up this project after figuring out what I can get from already available open source [configuration management software](http://en.wikipedia.org/wiki/Comparison_of_open_source_configuration_management_software) like [puppet](https://github.com/puppetlabs/puppet)

clenver
=======
[![Gem Version](https://badge.fury.io/rb/clenver.png)](http://badge.fury.io/rb/clenver) [![Build Status](https://travis-ci.org/pietrushnic/clenver.png?branch=master)](https://travis-ci.org/pietrushnic/clenver) [![Code Climate](https://codeclimate.com/github/pietrushnic/clenver.png)](https://codeclimate.com/github/pietrushnic/clenver) [![Coverage Status](https://coveralls.io/repos/pietrushnic/clenver/badge.png)](https://coveralls.io/r/pietrushnic/clenver)

clenver (Command Line home ENVironment mangER) is a Ruby gem that bootstrap and manage your shell environment. 

## Introduction

clenver aims to shorten time of configuring your brand new Linux account to fully featured development envionment of your choice by using:
* VCS (version control system) repositories
* directory creation
* symlinking

It also aims to reliably manage your exising environment by:
* easy switching between project workspaces
* report on the status of used repositories (like [oh-my-zsh](), [spf13-vim](), ...)

## Installation
Simply type in you shell:
```
gem install clenver
```
## Getting Started
### Bootstrap
clenver is able to bootstrap your brand new Linux account according to rules provided through YAML file. For 
xample create `dummy.yml` with below content:
```yaml
https://github.com/pietrushnic/dummy.git:
  links:
    foobar.txt:
    - foobar_link
    foobar:
    - foobar_dir_link
  run:
    - echo "success!!!"
  remotes:
    upstream:
    - https://github.com/pietrushnic/dummy.git
```
After that running
```
clenver init dummy.yaml
```
gives you below tree:
```
dummy
├── dummy
│   ├── foobar
│   ├── foobar.txt
│   └── README.md
├── foobar_dir_link -> $PWD/dummy/dummy/foobar
└── foobar_link -> $PWD/dummy/dummy/foobar.txt
```
And of course will display `success!!!` message. Carefully crafted YAML file can bootstrap you clean user account into fully configured user account.
## Examples
## Contribution
