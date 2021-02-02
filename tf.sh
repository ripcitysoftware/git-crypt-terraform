#!/usr/bin/env sh

###
#
# The purpose of this file is to wrap the terraform command
# If the command being run is "plan", we will verify the plan output
#
###

[[ ! -z "$DEBUG" ]] && set -x

validate_plan() {
    echo "Running CloudPolicy™ validation..."

    URL="${CLOUDMANAGER_API}/cloudpolicies/${CM_PROJECT_ID}"
    DATA="$(terraform show -json plan.tfplan)"
    RESPONSE=$(curl -X POST -H "Content-Type: application/json" -d "$DATA" $URL 2>/dev/null)
    test $(echo $RESPONSE | jq '.summary.valid') = 'true'

    if [ ! $? -eq 0 ]; then
        echo -e "\n\nYour CloudPolicy validation failed!\n\n"
        echo -e "For more details or to request a resolution visit:\n"
        VALIDATION_URL = $(echo $RESPONSE | jq '.validation_url')
        echo -e "\n\t$VALIDATION_URL"
        exit 1
    fi

    echo -e "\n\nYour planned changes pass CloudPolicy validation!"
}

terraform "$@"

if [[ "$1" = "plan" ]]; then
    validate_plan
fi
