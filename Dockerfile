FROM node:16

COPY . /opt/anon
WORKDIR /opt/anon

RUN  apt-get update \
 && apt-get install --yes build-essential libicu-dev chromium libgconf-2-4 libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 libgbm-dev libnss3-dev libxss-dev \
 && npm install \
 && ln -s /opt/anon/anon.js /usr/bin/anon

CMD ["anon"]
