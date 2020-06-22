# Secure Data Science Quickstart

## Table of Contents
1. Quick Deploy
1. Overview
1. License
1. Architecture Overview
1. Workflow Process
1. Features
1. Repository Breakdown

## Quick Deploy
Use the following links below to quickly deploy this repository to your AWS account.  No need to clone or fork the repository - the source code is available in Amazon S3 ready for deployment via CloudFormation.  To get started click one of the buttons below.

| Region | Launch Template |
|:---:|:---|
| Oregon (us-west-2) | [Deploy to AWS Oregon](https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-us-west-2/quickstart/ds_administration.yaml) |
| Ohio (us-east-2) | [Deploy to AWS Ohio](https://console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-us-east-2/quickstart/ds_administration.yaml) |
| N. Virginia (us-east-1) | [Deploy to AWS N. Virginia](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-us-east-1/quickstart/ds_administration.yaml) |
| Ireland (eu-west-1) | [Deploy to AWS Ireland](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-eu-west-1/quickstart/ds_administration.yaml) |
| London (eu-west-2) | [Deploy to AWS London](https://console.aws.amazon.com/cloudformation/home?region=eu-west-2#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-eu-west-2/quickstart/ds_administration.yaml) |
| Sydney (ap-southeast-2) | [Deploy to AWS Sydney](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-2#/stacks/create/review?stackName=secure-ds-core&templateURL=https://s3.amazonaws.com/sagemaker-workshop-cloudformation-ap-southeast-2/quickstart/ds_administration.yaml) |

## Overview

Amazon SageMaker is a powerful enabler and a key component of a data science environment, but it’s only part of what is required to build a complete and secure data science environment. For more robust security you will need other AWS services such as Amazon CloudWatch, Amazon S3, and AWS VPC. The following are some of the key things you will want in place, working in concert, with Amazon SageMaker.

### Private Network Environment

Your Virtual Private Cloud (VPC), which will be used to host Amazon SageMaker and other components of your data science environment, provides a familiar set of network-level controls to allow you to govern ingress and egress of data.  These templates create a VPC with no Internet Gateway (IGW), therefore all subnets are private, without Internet connectivity.  Network connectivity with AWS services or your own shared services is provided using [VPC endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html) and [PrivateLink](https://aws.amazon.com/privatelink/).  Security Groups are used to control traffic between different resources, allowing you to group like resources together and manage their ingress and egress traffic.

### Authentication and Authorization

AWS Identity and Access Management (IAM) can help you create preventive controls for many aspects of your data science enviroment.  They can control access to your data in Amazon S3, control who can access SageMaker resources like Notebook servers, and even be applied as VPC endpoint policies to put explicit controls around the API endpoints you create in your data science environment.

There are several IAM roles you will likely want in order to manage permissions and ensure separation of concerns at scale.  Those roles are:

- **Data scientist user role**

    Granting Console access, start/stop Jupyter notebook, open Jupyter notebook

- **Notebook creation role**

    Used by CI/CD pipeline or Service Catalog to create a Jupyter Notebook

- **Notebook execution role**

    Used by a Jupyter Notebook to access AWS resources

- **Training / Transform job execution role**

    Used by Training Job or Batch Transform job to access AWS resources like Amazon S3

- **Endpoint creation role**

    Used by your CI/CD pipeline to create hosted ML model endpoints

- **Endpoint hosting role**

    Used by a hosted ML model to access AWS resources such as Amazon S3

- **Endpoint invocation role**

    Used by an application to call a hosted ML model endpoint

There are also many [IAM conditions](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_actions-resources-contextkeys.html) you can apply in your policies to begin to grant powerful permissions but only under certain conditions.  

### Data Protection

In a data science environment there is the highly sensitive data you are using to train your ML models, but there is also the sensitive intellectual property you are developing in the form of algorithms, libraries, and trained models.  There are many ways to protect data such as the preventive controls described above, defined as IAM policies.  In addition you have the ability to encrypt data at rest using managed encryption keys.

Many AWS services, including Amazon S3 and Amazon SageMaker, are integrated with AWS Key Management Service (KMS) to make it very easy to encrypt your data at rest.  You can take advantage of these integrations to ensure that your data is encrypted in the data lake AND in the data science environment, end to end.  This encryption also applies to your intellectual property as it is being developed in the many places it may be stored such as Amazon S3, EC2 EBS volumes, or AWS CodeCommit git repository.

### Auditability

Using cloud services in a safe and responsible manner is good, but being able to demonstrate to others that you are operating in a governed manner is even better.  Developers and security officers alike will need to see activity logs for models being trained and persons interacting with the systems.  Amazon CloudWatch Logs and CloudTrail are there to help, receiving logs from many different parts of your data science environment to include:

 - Amazon S3
 - Amazon SageMaker Notebooks
 - Amazon SageMaker Training Jobs
 - Amazon SageMaker Hosted Models
 - VPC Flow Logs

## License

This source code is licensed under the MIT-0 License. See the LICENSE file.
