FROM node:boron

COPY . /opt/anon
WORKDIR /opt/anon

RUN  npm install \
 && ln -s /opt/anon/anon.js /usr/bin/anon

CMD ["anon"]

