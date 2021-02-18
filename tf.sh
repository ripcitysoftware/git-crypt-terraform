#!/usr/bin/env sh

###
#
# The purpose of this file is to wrap the terraform command
# If the command being run is "plan", we will verify the plan output
#
###

set -e

[[ ! -z "$DEBUG" ]] && set -x

validate_plan() {
    echo "Validating your changes against CloudPolicies"

    URL="${CM_VALIDATION_API}/cloudpolicies/${CM_PROJECT_ID}"
    terraform show -json plan.tfplan | jq '. | {CI_COMMIT_SHA: env.CI_COMMIT_SHA, CI_COMMIT_SHORT_SHA: env.CI_COMMIT_SHORT_SHA, CI_COMMIT_TITLE: env.CI_COMMIT_TITLE, CI_JOB_URL: env.CI_JOB_URL, CI_PIPELINE_IID: env.CI_PIPELINE_IID, CI_PIPELINE_URL: env.CI_PIPELINE_URL, CI_PROJECT_ID: env.CI_PROJECT_ID, GITLAB_USER_EMAIL: env.GITLAB_USER_EMAIL, GITLAB_USER_LOGIN: env.GITLAB_USER_LOGIN, GITLAB_USER_NAME: env.GITLAB_USER_NAME, CM_PROJECT_ID: env.CM_PROJECT_ID, CM_ORG_ID: env.CM_ORG_ID, CM_ENVIRONMENT_NAME: env.ENV, CM_STATE: .}' >request.json
    RESPONSE=$(curl -X POST -H "Content-Type: application/json" -d @request.json $URL 2>/dev/null)

    if [[ "$(echo $RESPONSE | jq '.passed')" != "true" ]]; then
        echo -e "\n\nYour CloudPolicy validation failed!\n\n"
        echo -e "For more details or to request a resolution visit:\n"
        VALIDATION_URL="$(echo $RESPONSE | jq -r '.validation_url')"
        echo -e "\n\t$VALIDATION_URL"
        exit 1
    fi

    echo -e "\n\nYour planned changes pass CloudPolicy validation!\n"
}

terraform "$@"

if [[ "$1" = "plan" ]]; then
    if [[ -z "$SKIP_VALIDATION" ]]; then
        validate_plan
    fi
fi
