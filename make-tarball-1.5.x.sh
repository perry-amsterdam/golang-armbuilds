#!/bin/bash

# we need this env var for the Go 1.5.x bootstrap build process
GOROOT_BOOTSTRAP=$HOME/go1.4 

# install a pre-compiled Go 1.4.x tarball to bootstrap
GO_VERSION=1.4.3
rm -fr $GOROOT_BOOTSTRAP
mkdir -p $GOROOT_BOOTSTRAP
curl -sSL https://github.com/DieterReuter/golang-armbuilds/releases/download/v${GO_VERSION}/go${GO_VERSION}.linux-armv7.tar.gz | tar xz -C $GOROOT_BOOTSTRAP --strip-components=1

# fetch Go 1.5.x source tarball
GO_VERSION=1.5
GOARM=7
rm -fr /usr/local/go
curl -sSL https://storage.googleapis.com/golang/go${GO_VERSION}.src.tar.gz | tar xz -C /usr/local

# now compile Go 1.5.x and package it as a tarball
pushd /usr/local/go/src
time ./make.bash --no-clean 2>&1
cd ../..
tar cfz go${GO_VERSION}.linux-armv${GOARM}.tar.gz ./go
popd
mv /usr/local/go${GO_VERSION}.linux-armv${GOARM}.tar.gz .

# cleanup
rm -fr $GOROOT_BOOTSTRAP
rm -fr /usr/local/go
