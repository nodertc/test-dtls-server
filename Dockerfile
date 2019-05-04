FROM alpine:3.9.3

WORKDIR /opt/workdir

COPY ./dtlsd.c ./
COPY ./*.pem ./
COPY ./Makefile ./

RUN addgroup -g 1000 dtls \
    && adduser -u 1000 -G dtls -s /bin/sh -D dtls \
    && apk add --no-cache --virtual .build-deps \
      pkgconfig \
      m4 \
      gzip \
      xz \
      curl \
      tar \
      gcc \
      g++ \
      make \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && ln -s $PWD/dtlsd /usr/bin/dtlsd \
    && make clean \
    && apk del .build-deps

RUN cp ./build/lib/*.so.* /usr/lib/ && rm -rf build/bin

USER dtls

EXPOSE 4444

CMD [ "dtlsd" ]
