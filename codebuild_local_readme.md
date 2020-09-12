# AWS CodeBuild Local Mode

## Overview

AWS CodeBuild can be used locally through the use of Docker containers.  This gives developers the ability to develop and test
their buildspec.yaml files locally before commiting them to the Git repository.  Equally it could be used to locally deploy and
test code before publishing it to the repository.  The rest of this readme details how to setup and use CodeBuild Local with
this repository in case you're unfamiliar.

## Prerequisites

AWS CodeBuild Local relies on 2 Docker Containers. The first, (aws-codebuild-local)[https://hub.docker.com/r/amazon/aws-codebuild-local/]
acts as the service daemon, monitoring the build.  The second container is the hosting contianer used to execute the project
buildspec.yaml.  This second container is not published to Docker Hub and so must be built.  Alternatively you can specify your
own build container.

### Build the AWS CodeBuild standard build container

```bash
git clone https://github.com/aws/aws-codebuild-docker-images.git
cd ubuntu/standard/4.0
docker build -t aws/codebuild/standard:4.0 .
```

This will download the source for and build the standard Ubuntu build container.

> Note: this build will take about 30 min.

## Execute the build

To run CodeBuild locally use the shell script `codebuild_local.sh` to kick things off:

```bash
./codebuild_local.sh -i 'aws/codebuild/standard:4.0' -f .
```

This will install any dependencies such as zip, Python pip, and the AWS CLI.  It will then execute the `package_cloudformation.sh`
shell script to package this repository's cloudformation and publish it to Amazon S3 for your use.
