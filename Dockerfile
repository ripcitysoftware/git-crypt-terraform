FROM hashicorp/terraform:0.13.5
LABEL maintainer "chris.maki@ripcitysoftware.com"

COPY session.sh /usr/bin/session.sh
COPY tf.sh /usr/bin/tf
RUN apk add git-crypt curl jq aws-cli --update && \
    chmod +x /usr/bin/session.sh && \
    chmod +x /usr/bin/tf

ENTRYPOINT ["/usr/bin/session.sh"]
