#!/bin/bash

# Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

set -e

# This script will package the CloudFormation in this directory, and the source code in this repository, and upload it 
# to Amazon S3 in preparation for deployment using the AWS CloudFromation service.  
# 
# This script exists because Service Catalog products, when using relative references to cloudformation templates are 
# not properly packaged by the AWS cli. Also the full stack, due to 2 levels of Service Catalog deployment will not 
# always package properly using the AWS cli.

# This script treats the templates as source code and packages them, putting the results into a 'build' subdirectory.

# This script assumes a Linux or MacOSX environment and relies on the following software packages being installed:
# . - AWS Command Line Interface (CLI)
# . - sed
# . - Python 3 / pip3
# . - zip

# PLEASE NOTE this script will store all resources to an Amazon S3 bucket s3://${CFN_BUCKET_NAME}/${PROJECT_NAME}
CFN_BUCKET_NAME=${CFN_BUCKET_NAME:="secure-data-science-cloudformation-$RANDOM-$AWS_DEFAULT_REGION"}
PROJECT_NAME="quickstart"
# files that wont be uploaded by `aws cloudformation package`
UPLOAD_LIST="ds_environment.yaml ds_notebook_v1.yaml ds_notebook_v2.yaml project_template.zip ds_administration.yaml" 
# files that need to be scrubbed with sed to replace < S3 BUCKET LOCATION > with an actual S3 bucket name
SELF_PACKAGE_LIST="ds_administration.yaml ds_env_catalog.yaml ds_env_backing_store.yaml ds_shared_services_ecs.yaml"
# files to be packaged using `aws cloudformation package`
AWS_PACKAGE_LIST="ds_environment.yaml ds_administration.yaml"
TMP_OUTPUT_DIR="/tmp/build/${AWS_DEFAULT_REGION}"
PUBLISH_PYPI=${PUBLISH_PYPI:True}

if aws s3 ls s3://${CFN_BUCKET_NAME} 2>&1 | grep NoSuchBucket
then
    echo Creating Amazon S3 bucket ${CFN_BUCKET_NAME}
    aws s3 mb s3://${CFN_BUCKET_NAME} --region $AWS_DEFAULT_REGION
fi
echo Preparing content for publication to Amazon S3 s3://${CFN_BUCKET_NAME}

## clean away any previous builds of the CFN
rm -fr ${TMP_OUTPUT_DIR}
mkdir -p ${TMP_OUTPUT_DIR}
cp cloudformation/*.yaml ${TMP_OUTPUT_DIR}

echo "Zipping code sample..."
pushd src/project_template
zip -r ${TMP_OUTPUT_DIR}/project_template.zip ./*
popd

echo "Zipping detective control..."
pushd src/detective_control
zip -r ${TMP_OUTPUT_DIR}/vpc_detective_control.zip ./*
popd

if $PUBLISH_PYPI; then
    echo "Downloading Python modules for PyPI mirror..."
    mkdir -p ${TMP_OUTPUT_DIR}/pypimirror
    pip3 download -d ${TMP_OUTPUT_DIR}/pypimirror \
        awswrangler==1.0.4 stepfunctions==1.0.0.8 smdebug==0.7.2 shap==0.35.0 sagemaker-experiments==0.1.13 
    pip3 download -d ${TMP_OUTPUT_DIR}/pypimirror \
        --platform manylinux1_x86_64 \
        --only-binary=:all: \
        --implementation cp \
        --abi cp36m \
        --python-version "3.6.1" \
        numpy==1.18.4 pandas==1.0.3 protobuf==3.11.3 pyarrow==0.16.0 scikit_learn==0.22.2 scipy==1.4.1 psycopg2==2.7.7 xgboost==0.90
fi

## publish materials to target AWS regions
REGION=${AWS_DEFAULT_REGION:="eu-west-1"}
echo Publishing CloudFormation to ${REGION}

echo "Clearing ${CFN_BUCKET_NAME}..."
if $PUBLISH_PYPI; then
    aws s3 rm \
        s3://${CFN_BUCKET_NAME}/${PROJECT_NAME}/ \
        --recursive \
        --region ${REGION}

    echo "Copying PyPI mirror wheels to S3..."
    aws s3 sync ${TMP_OUTPUT_DIR}/pypimirror s3://${CFN_BUCKET_NAME}/${PROJECT_NAME}/pypimirror
else
    aws s3 rm \
        s3://${CFN_BUCKET_NAME}/${PROJECT_NAME}/ \
        --recursive \
        --exclude "pypimirror/*" \
        --region ${REGION}
fi

echo "Self-packaging some Cloudformation templates..."
for fname in ${SELF_PACKAGE_LIST};
do
    sed -e "s/< S3_CFN_STAGING_PATH >/${PROJECT_NAME}/" cloudformation/${fname} > ${TMP_OUTPUT_DIR}/${fname}
    sed -e "s/< S3_CFN_STAGING_BUCKET >/${CFN_BUCKET_NAME}/" ${TMP_OUTPUT_DIR}/${fname} > ${TMP_OUTPUT_DIR}/${fname}
    sed -e "s/< S3_CFN_STAGING_BUCKET_PATH >/${CFN_BUCKET_NAME}\/${PROJECT_NAME}/" ${TMP_OUTPUT_DIR}/${fname} > ${TMP_OUTPUT_DIR}/${fname}
done

echo "Packaging Cloudformation templates..."
for fname in ${AWS_PACKAGE_LIST};
do
    pushd ${TMP_OUTPUT_DIR}
    aws cloudformation package \
        --template-file ${fname} \
        --s3-bucket ${CFN_BUCKET_NAME} \
        --s3-prefix ${PROJECT_NAME} \
        --output-template-file ${TMP_OUTPUT_DIR}/${fname}-${REGION} \
        --region ${REGION}
    popd
done

# push files to S3, note this does not 'package' the templates
echo "Copying cloudformation templates and files to S3..."
for fname in ${UPLOAD_LIST};
do
    if [ -f ${TMP_OUTPUT_DIR}/${fname}-${REGION} ]; then
        aws s3 cp ${TMP_OUTPUT_DIR}/${fname}-${REGION} s3://${CFN_BUCKET_NAME}/${PROJECT_NAME}/${fname}
    else
        aws s3 cp ${TMP_OUTPUT_DIR}/${fname} s3://${CFN_BUCKET_NAME}/${PROJECT_NAME}/${fname}
    fi
done

echo ==================================================
echo "Publication complete"
echo "To deploy execute:"
echo "   aws cloudformation create-stack --template-url https://s3.${REGION}.amazonaws.com/${CFN_BUCKET_NAME}/${PROJECT_NAME}/ds_administration.yaml --region ${REGION} --stack-name ds-administration --capabilities CAPABILITY_NAMED_IAM" 
