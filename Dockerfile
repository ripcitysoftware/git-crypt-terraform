FROM hashicorp/terraform:0.12.26
MAINTAINER chris.maki@ripcitysoftware.com

RUN apk add git-crypt curl --update
