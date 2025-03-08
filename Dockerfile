FROM node:16.16.0-alpine

LABEL maintainer="Nightscout Contributors"

WORKDIR /opt/app
ADD . /opt/app

# TODO: We should be able to do `RUN npm install --only=production`.
# For this to work, we need to copy only package.json and things needed for `npm`'s to succeed.
# TODO: Do we need to re-add `npm audit fix`? Or should that be part of a development process/stage?
RUN rm -rf package-lock.json node_modules
RUN npm cache clean --force
RUN apk add --no-cache git
RUN npm install --no-cache
RUN npm audit fix
RUN npm run postinstall
RUN npm run env
RUN rm -rf /tmp/*
  # TODO: These should be added in the future to correctly cache express-minify content to disk
  # Currently, doing this breaks the browser cache.
  # mkdir /tmp/public && \
  # chown node:node /tmp/public

USER node
EXPOSE 1337

CMD ["node", "lib/server/server.js"]
