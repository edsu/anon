FROM node:16

COPY . /opt/anon
WORKDIR /opt/anon

RUN  apt-get update \
 && apt-get install --yes build-essential libicu-dev \
 && npm install \
 && ln -s /opt/anon/anon.js /usr/bin/anon

CMD ["anon"]
