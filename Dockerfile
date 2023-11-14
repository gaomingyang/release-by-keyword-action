FROM alpine

RUN apk add --no-cache \
        bash \
        curl \
        jq && \
        which bash && \
        which curl && \
        which jq

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY sample_push_event.json /sample_push_event.json

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]