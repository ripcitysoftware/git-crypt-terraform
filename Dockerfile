FROM hashicorp/terraform:light
MAINTAINER chris.maki@ripcitysoftware.com

RUN apk add git-crypt curl --update
