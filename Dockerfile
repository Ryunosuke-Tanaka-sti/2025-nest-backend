ARG NODE_VER
FROM node:${NODE_VER}

RUN npm install -g npm@11.0.0
RUN npm i -g @nestjs/cli

USER node

WORKDIR /home/node/app

RUN mkdir nest-app
COPY --chown=node:node nest-app nest-app

WORKDIR /home/node/app/nest-app
RUN mkdir node_modules
RUN chown node:node node_modules

RUN npm install