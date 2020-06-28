# Secure Data Science Quickstart

## Overview

Amazon SageMaker is a powerful enabler and a key component of a data science environment, but it’s only part of what is required to build a complete and secure data science environment. For more robust security you will need other AWS services such as Amazon CloudWatch, Amazon S3, and AWS VPC. The following are some of the key things you will want in place, working in concert, with Amazon SageMaker.

## Table of Contents
1. Quick Deploy
1. License
1. Features
1. Architecture Overview
1. Repository Breakdown

## Quick Deploy
Use the following links below to quickly deploy this repository to your AWS account.  No need to clone or fork the repository - the source code is available in Amazon S3 ready for deployment via CloudFormation.  To get started click one of the buttons below.

| Region | Launch Template |
|:---:|:---|
| Oregon (us-west-2) | [![Deploy to AWS Oregon](https://camo.githubusercontent.com/9c49a15ad7e4c64cae6fc0d4448935283b5cd71a/68747470733a2f2f63646e2e7261776769742e636f6d2f6275696c646b6974652f636c6f7564666f726d6174696f6e2d6c61756e63682d737461636b2d627574746f6e2d7376672f6d61737465722f6c61756e63682d737461636b2e737667 "Deploy to AWS Oregon")](https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-us-west-2/quickstart/ds_administration.yaml) |
| Ohio (us-east-2) | [![Deploy to AWS Ohio](https://camo.githubusercontent.com/9c49a15ad7e4c64cae6fc0d4448935283b5cd71a/68747470733a2f2f63646e2e7261776769742e636f6d2f6275696c646b6974652f636c6f7564666f726d6174696f6e2d6c61756e63682d737461636b2d627574746f6e2d7376672f6d61737465722f6c61756e63682d737461636b2e737667 "Deploy to AWS Ohio")](https://console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-us-east-2/quickstart/ds_administration.yaml) |
| N. Virginia (us-east-1) | [![Deploy to AWS N. Virginia](https://camo.githubusercontent.com/9c49a15ad7e4c64cae6fc0d4448935283b5cd71a/68747470733a2f2f63646e2e7261776769742e636f6d2f6275696c646b6974652f636c6f7564666f726d6174696f6e2d6c61756e63682d737461636b2d627574746f6e2d7376672f6d61737465722f6c61756e63682d737461636b2e737667 "Deploy to AWS N. Virginia")](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-us-east-1/quickstart/ds_administration.yaml) |
| Ireland (eu-west-1) | [![Deploy to AWS Ireland](https://camo.githubusercontent.com/9c49a15ad7e4c64cae6fc0d4448935283b5cd71a/68747470733a2f2f63646e2e7261776769742e636f6d2f6275696c646b6974652f636c6f7564666f726d6174696f6e2d6c61756e63682d737461636b2d627574746f6e2d7376672f6d61737465722f6c61756e63682d737461636b2e737667 "Deploy to AWS Ireland")](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-eu-west-1/quickstart/ds_administration.yaml) |
| London (eu-west-2) | [![Deploy to AWS London](https://camo.githubusercontent.com/9c49a15ad7e4c64cae6fc0d4448935283b5cd71a/68747470733a2f2f63646e2e7261776769742e636f6d2f6275696c646b6974652f636c6f7564666f726d6174696f6e2d6c61756e63682d737461636b2d627574746f6e2d7376672f6d61737465722f6c61756e63682d737461636b2e737667 "Deploy to AWS London")](https://console.aws.amazon.com/cloudformation/home?region=eu-west-2#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-eu-west-2/quickstart/ds_administration.yaml) |
| Sydney (ap-southeast-2) | [![Deploy to AWS Sydney](https://camo.githubusercontent.com/9c49a15ad7e4c64cae6fc0d4448935283b5cd71a/68747470733a2f2f63646e2e7261776769742e636f6d2f6275696c646b6974652f636c6f7564666f726d6174696f6e2d6c61756e63682d737461636b2d627574746f6e2d7376672f6d61737465722f6c61756e63682d737461636b2e737667 "Deploy to AWS Sydney")](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-2#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-ap-southeast-2/quickstart/ds_administration.yaml) |

## License

This source code is licensed under the [MIT-0 License](https://github.com/aws/mit-0). See the [LICENSE](LICENSE) file for details.

## Features

This source code demonstrates a self-service model for enabling project teams to create data science environments that employ a number of recommended security practices.  Some of the more notable features are listed below.  The controls, mechanisms, and services deployed by this source code is intended to provide operations and security teams with the assurance that their best practice is being employed while also enabling project teams to self service, move quickly, and stay focused on the data science task at hand.

### Private Network per Data Science Environment

For every data science environment created a Virtual Private Cloud (VPC) is deployed to host Amazon SageMaker and other components of the data science environment.  The VPC provides a familiar set of network-level controls to allow you to govern ingress and egress of data.  These templates create a VPC with no Internet Gateway (IGW), therefore all subnets are private, without Internet connectivity.  Network connectivity with AWS services or your own shared services is provided using [VPC endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html) and [PrivateLink](https://aws.amazon.com/privatelink/).  Security Groups are used to control traffic between different resources, allowing you to group like resources together and manage their ingress and egress traffic.

### Authentication and Authorization

AWS Identity and Access Management (IAM) is used to create least-privilege, preventive controls for many aspects of the data science enviroments.  These preventive controls, in the form of IAM policies, are used to control access to a project's data in Amazon S3, control who can access SageMaker resources like Notebook servers, and are also applied as VPC endpoint policies to put explicit controls around the API endpoints created in a data science environment.

There are several IAM roles deployed by this source code to manage permissions and ensure separation of concerns at scale.  Those roles are:

- **Data scientist user role**

    Granting Console access, start/stop Jupyter notebook, open Jupyter notebook, create Jupyter notebook via Service Catalog

- **Notebook execution role**

    Used by a Jupyter Notebook to access AWS resources, this is created on a per user per notebook basis.  This role can be re-used for training jobs, batch transformations, and other Amazon SageMaker resources to support auditbility.

The IAM policies created by this source code use many [IAM conditions](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_actions-resources-contextkeys.html) to grant powerful permissions but only under certain conditions.  

### Data Protection

It is assumed that a data science environment contains highly sensitive data to train ML models, and that there is also sensitive intellectual property in the form of algorithms, libraries, and trained models.  There are many ways to protect data such as the preventive controls described above, defined as IAM policies.  In addition this source code encrypts data at rest using managed encryption keys.

Many AWS services, including Amazon S3 and Amazon SageMaker, are integrated with AWS Key Management Service (KMS) to make it very easy to encrypt your data at rest.  This source code takes advantage of these integrations to ensure that your data is encrypted in Amazon S3 and on Amazon SageMaker resources, end to end.  This encryption is also applied to your intellectual property as it is being developed in the many places it may be stored such as Amazon S3, EC2 EBS volumes, or AWS CodeCommit git repository.

### Auditability

Using cloud services in a safe and responsible manner is good, but being able to demonstrate to others that you are operating in a governed manner is even better.  Developers and security officers alike will need to see activity logs for models being trained and persons interacting with the systems.  Amazon CloudWatch Logs and CloudTrail are there to help, receiving logs from many different parts of your data science environment to include:

 - Amazon S3
 - Amazon SageMaker Notebooks
 - Amazon SageMaker Training Jobs
 - Amazon SageMaker Hosted Models
 - VPC Flow Logs

## Architecture Overview

![High-level Architecture](docs/images/hla.png High-level architecture)

## Repository Breakdown