#!/bin/bash
REPO_NAME="$ECR_REPO"
ECR_ACCOUNT="$ECR_ACCOUNT_URL"
ECR_REPO="${ECR_ACCOUNT}/${REPO_NAME}"
TAG="latest"
#Login to the Docker registry on ECR.
aws ecr get-login-password --region us-east-1  | sed -e 's/^.*-p \(.*\)\s\-\e.*$/\1/' |  docker login --password-stdin -u AWS "${ECR_REPO}"
#Build the image
docker build -t "${TAG}" .
# Push using the commit tag.
docker tag "${TAG}:latest" "${ECR_REPO}:latest"
#Push using the latest tag.
docker push "${ECR_REPO}:latest"
