#!/usr/bin/env bash

# Get dart executable
cp `which dart` ./

# Make app snapshot
dart --snapshot=app.dart.snapshot ../../bin/serve.dart

# Tar the necessary files
tar -czvf serve.tar.gz dart app.dart.snapshot

# Build docker image
docker build --tag serve .