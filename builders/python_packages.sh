#!/bin/bash

set -e
set -x

. $( dirname $0 )/common

## Figuring out the full dependency tree and what's already available via yum is
## totally manual.  This script reflects that state, but there's probably a
## better way…

## supervisor requires meld3, available in epel repo.  no declared dependency on
## setuptools, but won't start without it.
pkg_exists_in_repo python-supervisor-3.1.3 || \
    fpm -s python \
        -t rpm \
        -v 3.1.3 \
        -d python-setuptools \
        supervisor

## pip requires setuptools, available in base repo
pkg_exists_in_repo python-pip-1.4.1 || fpm -s python -t rpm -v 1.4.1 pip

pkg_exists_in_repo python-twisted-11.1.0       || fpm -s python -t rpm -v 11.1.0 Twisted
pkg_exists_in_repo python-zope.interface-4.0.5 || fpm -s python -t rpm -v 4.0.5  zope.interface
pkg_exists_in_repo python-txamqp-0.6.2         || fpm -s python -t rpm -v 0.6.2  txamqp

## --provides required by python-django-tagging, and for compatibility with
## python-Django package in EPEL
pkg_exists_in_repo python-django-1.3 || fpm -s python -t rpm --provides Django Django==1.3

graphite_ver="0.9.12"
pkg_exists_in_repo python-carbon-${graphite_ver}       || fpm -s python -t rpm -v ${graphite_ver} carbon
pkg_exists_in_repo python-whisper-${graphite_ver}      || fpm -s python -t rpm -v ${graphite_ver} whisper
pkg_exists_in_repo python-graphite-web-${graphite_ver} || fpm -s python -t rpm -v ${graphite_ver} graphite-web

## my docker-sync stuff
## deps are a bit fucked up; epel provides PyYAML-3.10 and fpm doesn't have an
## option to remove an item from the list of automatic dependencies
## it also won't even fucking start if mock 1.0.1 isn't installed, even though
## that's not a dependency that's actually used at runtime.
docker_sync_ver="1.2.3"
docker_sync_iter="2"
pkg_exists_in_repo python-docker-sync-${docker_sync_ver}-${docker_sync_iter} || \
    fpm -s python \
        -t rpm \
        --no-auto-depends \
        -d 'PyYAML >= 3.10' \
        -d 'PyYAML < 4.0' \
        -d 'python-argparse >= 1.1' \
        -d 'python-docker-py >= 0.4.0' \
        -d 'python-docker-py <= 0.6.0' \
        -d 'python-semantic_version >= 2.3.1' \
        -d 'python-semantic_version < 2.4.0' \
        -d 'python-setuptools' \
        -v ${docker_sync_ver} \
        --iteration ${docker_sync_iter} \
        docker-sync

pkg_exists_in_repo python-mock-1.0.1              || fpm -s python -t rpm -v 1.0.1  mock
pkg_exists_in_repo python-docker-py-0.6.0         || fpm -s python -t rpm -v 0.6.0  docker-py
pkg_exists_in_repo python-websocket-client-0.11.0 || fpm -s python -t rpm -v 0.11.0 websocket-client
pkg_exists_in_repo python-requests-2.2.1          || fpm -s python -t rpm -v 2.2.1  requests
pkg_exists_in_repo python-semantic_version-2.3.1  || fpm -s python -t rpm -v 2.3.1  semantic_version

## awscli and friends
pkg_exists_in_repo python-awscli-1.6.5     || fpm -s python -t rpm -v 1.6.5  awscli
pkg_exists_in_repo python-bcdoc-0.12.2     || fpm -s python -t rpm -v 0.12.2 bcdoc
pkg_exists_in_repo python-botocore-0.76.0  || fpm -s python -t rpm -v 0.76.0 botocore
pkg_exists_in_repo python-colorama-0.2.5   || fpm -s python -t rpm -v 0.2.5  colorama
pkg_exists_in_repo python-dateutil-2.3     || fpm -s python -t rpm -v 2.3    python-dateutil
pkg_exists_in_repo python-docutils-0.12    || fpm -s python -t rpm -v 0.12   docutils
pkg_exists_in_repo python-jmespath-0.5.0   || fpm -s python -t rpm -v 0.5.0  jmespath
pkg_exists_in_repo python-pyasn1-0.1.7     || fpm -s python -t rpm -v 0.1.7  pyasn1
pkg_exists_in_repo python-rsa-3.1.2        || fpm -s python -t rpm -v 3.1.2  rsa
pkg_exists_in_repo python-simplejson-3.3.0 || fpm -s python -t rpm -v 3.3.0  simplejson
