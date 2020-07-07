FROM quay.io/helmpack/chart-releaser:latest

ARG proxy=http://www-proxy-brmdc.us.oracle.com:80
ARG no_proxy=localhost,.oraclecorp.com,.oracle.com

ENV https_proxy ${proxy}
ENV http_proxy ${proxy}
ENV no_proxy ${no_proxy}

USER root
WORKDIR /app

RUN apk update && apk add curl bash openssl

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh && rm -rf ./get_helm.sh

COPY config.yaml config.yaml
COPY charts charts

RUN helm package charts/* -d .deploy

CMD cr index --config config.yaml && cat index.yaml