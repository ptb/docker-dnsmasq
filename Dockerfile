FROM alpine:3.2
# MAINTAINER Peter T Bosse II <ptb@ioutime.com>

RUN apk add --update-cache \
    dnsmasq \
    wget \

  && wget \
    --no-check-certificate \
    --output-document - \
    --quiet \
    https://api.github.com/repos/just-containers/s6-overlay/releases/latest \
    | sed -n "s/^.*browser_download_url.*: \"\(.*s6-overlay-amd64.tar.gz\)\".*/\1/p" \
    | wget \
      --input-file - \
      --no-check-certificate \
      --output-document - \
      --quiet \
    | tar xz -C / \

  && mkdir -p /etc/services.d/dnsmasq/ \

  && apk del \
    wget \
  && rm -rf /tmp/* /var/cache/apk/*

COPY ["run", "/etc/services.d/dnsmasq/"]
ENTRYPOINT ["/init"]
EXPOSE 53 53/udp 67/udp

# docker build --rm --tag ptb2/dnsmasq .
# docker run --cap-add=NET_ADMIN --detach --name dnsmasq --net host \
#   --publish 53:53/tcp \
#   --publish 53:53/udp \
#   --publish 67:67/udp \
#   --volume /volume1/@appstore/dnsmasq/dnsmasq.conf:/etc/dnsmasq.conf \
#   ptb2/dnsmasq
