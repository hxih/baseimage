FROM alpine
MAINTAINER hxih
ENV LANG=en_US.UTF-8
RUN GLIBC_GITHUB_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    VERSION="2.30-r0" && \
    BASE_PACKAGE="glibc-$VERSION.apk" && \
    BIN_PACKAGE="glibc-bin-$VERSION.apk" && \
    I18N_PACKAGE="glibc-i18n-$VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub &&\
    wget \
        "$GLIBC_GITHUB_URL/$VERSION/$BASE_PACKAGE" \
        "$GLIBC_GITHUB_URL/$VERSION/$BIN_PACKAGE" \
        "$GLIBC_GITHUB_URL/$VERSION/$I18N_PACKAGE" && \
    apk add --no-cache tzdata "$BASE_PACKAGE" "$BIN_PACKAGE" "$I18N_PACKAGE" && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 "$LANG" || true && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del .build-dependencies && \
    apk del glibc-i18n && \
    rm \
        "$BASE_PACKAGE" \
        "$BIN_PACKAGE" \
        "$I18N_PACKAGE" \
        "/etc/apk/keys/sgerrand.rsa.pub" \
        "/root/.wget-hsts"
WORKDIR /opt
