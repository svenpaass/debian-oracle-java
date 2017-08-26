#!/bin/sh
VERSION=8u144

docker build -t svenpaass/debian-oracle-java:${VERSION} \
  -t svenpaass/debian-oracle-java:${VERSION%u*} \
  -t svenpaass/debian-oracle-java:latest .
