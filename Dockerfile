FROM alpine:3.21

ARG TARGETARCH
RUN apk add --no-cache ca-certificates curl unzip \
    && case "${TARGETARCH:-amd64}" in amd64) XRAY_ARCH=64 ;; arm64) XRAY_ARCH=arm64-v8a ;; *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; esac \
    && curl -fsSL "https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-${XRAY_ARCH}.zip" -o /tmp/xray.zip \
    && unzip -q /tmp/xray.zip xray -d /usr/local/bin \
    && chmod +x /usr/local/bin/xray \
    && rm /tmp/xray.zip \
    && apk del curl unzip

COPY config.json /etc/xray/config.json
EXPOSE 8080
CMD ["/usr/local/bin/xray", "run", "-config", "/etc/xray/config.json"]
