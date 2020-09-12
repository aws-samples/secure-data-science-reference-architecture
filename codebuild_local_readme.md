# AWS CodeBuild Local Mode

## Overview

AWS CodeBuild can be used locally through the use of Docker containers.  This gives developers the ability to develop and test
their buildspec.yaml files locally before commiting them to the Git repository.  Equally it could be used to locally deploy and
test code before publishing it to the repository.  The rest of this readme details how to setup and use CodeBuild Local with
this repository in case you're unfamiliar.

## Prerequisites

AWS CodeBuild Local relies on 2 Docker Containers. The first, (aws-codebuild-local)[https://hub.docker.com/r/amazon/aws-codebuild-local/]
acts as the service daemon, monitoring the build.  The second container is the hosting contianer used to execute the project
buildspec.yaml.  For the purpose of this project the latest Ubuntu image should suffice.

To get these two containers the following commands should be executed:

```bash
docker pull amazon/aws-codebuild-local
docker pull ubuntu
```

## Execute the build

To run CodeBuild locally use the shell script `codebuild_local.sh` to kick things off:

```bash
./codebuild_local.sh -i 'ubuntu:latest' -c -a /tmp -s .
```

This will install any dependencies such as zip, Python pip, and the AWS CLI.  It will then execute the `package_cloudformation.sh`
shell script to package this repository's cloudformation and publish it to Amazon S3 for your use.
