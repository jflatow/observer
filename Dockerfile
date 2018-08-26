FROM alpine:latest

RUN apk add --update chromium make nodejs nodejs-npm

ENV WD /mnt/observer
RUN mkdir $WD
WORKDIR $WD
COPY . $WD
RUN make

ENV RDP=$RDP
ENV LRDP=$LRDP
ENV NOTEBOOKS=
ENTRYPOINT bin/observer $RDP $LRDP $NOTEBOOKS
