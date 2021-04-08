ARG NODE_VERSION=14

FROM node:$NODE_VERSION-alpine

ENV APP_PATH /opt/todo

WORKDIR $APP_PATH

COPY . $APP_PATH/

RUN npm install && npm audit fix

CMD ["node", "server.js"]

EXPOSE 8080
