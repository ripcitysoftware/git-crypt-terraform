FROM hashicorp/terraform:0.13.2
LABEL maintainer "chris.maki@ripcitysoftware.com"

COPY session.sh /usr/bin/session.sh
RUN apk add git-crypt curl jq --update && \
    chmod +x /usr/bin/session.sh

ENTRYPOINT ["/usr/bin/session.sh"]
