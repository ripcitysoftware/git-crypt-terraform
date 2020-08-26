#!/usr/bin/env sh

[[ ! -z "$DEBUG" ]] && set -x
set -x

DATA="$(jq -n '{org_id: env.CM_ORG_ID, project_id: env.CM_PROJECT_ID, token: env.CM_TOKEN}')"
RESPONSE=$(curl -X POST -H "Content-Type: application/json" -d "$DATA" ${CLOUDMANAGER_API}/integrations/aws/session 2>/dev/null)

# TODO some check against the response

export AWS_ACCESS_KEY_ID=$(echo $RESPONSE | jq .aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(echo $RESPONSE | jq .aws_secret_access_key)
export AWS_SESSION_TOKEN=$(echo $RESPONSE | jq .aws_session_token)
