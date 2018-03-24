FROM alpine:3.7
MAINTAINER http://wtanaka.com/dockerfiles
RUN apk add --no-cache sudo
COPY run-as-hostuid.sh /
ENTRYPOINT ["/run-as-hostuid.sh"]
