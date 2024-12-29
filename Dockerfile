ARG NODE_VER
FROM node:${NODE_VER} as base
RUN npm install -g npm@11.0.0

FROM base as dev

RUN npm i -g @nestjs/cli

USER node

WORKDIR /home/node/app

RUN mkdir nest-app
COPY --chown=node:node nest-app nest-app

WORKDIR /home/node/app/nest-app
RUN mkdir node_modules
RUN chown node:node node_modules

RUN npm install

FROM node:${NODE_VER} as builder

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini


FROM base
WORKDIR /home/node/app

RUN apt-get update && apt-get install -y unattended-upgrades
RUN unattended-upgrade -v
ENV NODE_ENV prod

COPY --from=builder /tini /tini
COPY --chown=node:node ./backend/node_modules/ ./node_modules/
COPY --chown=node:node ./backend/dist ./dist/

USER node
ENTRYPOINT ["/tini", "--"]
CMD ["node", "dist/main.js"]