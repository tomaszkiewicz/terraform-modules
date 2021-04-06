#!/bin/bash

if [[ -z "$ROLE_ARN" ]]; then
  echo "==> skipping assume role as no role specified"
  return
fi

echo "==> assuming role $ROLE_ARN"
output=$(aws sts assume-role --role-arn "$ROLE_ARN" --role-session-name "assumed-role")

echo "==> role $ROLE_ARN assumed"
export AWS_ACCESS_KEY_ID=$(echo $output | jq -c '.Credentials.AccessKeyId' | tr -d '"' | tr -d ' ')
export AWS_SECRET_ACCESS_KEY=$(echo $output | jq -c '.Credentials.SecretAccessKey' | tr -d '"' | tr -d ' ')
export AWS_SESSION_TOKEN=$(echo $output  | jq -c '.Credentials.SessionToken' | tr -d '"' | tr -d ' ')