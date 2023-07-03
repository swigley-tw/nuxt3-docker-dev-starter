FROM node:lts as builder

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --prefer-offline --pure-lockfile --non-interactive --production=false

COPY . .
# The following line was just added for opening the issue
RUN npx nuxi info # this was added
RUN yarn build

FROM node:lts-alpine

WORKDIR /app

COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/yarn.lock ./yarn.lock


RUN NODE_ENV=development yarn install  
COPY --from=builder /app/.output ./.output

ENV HOST 0.0.0.0

EXPOSE 3000

ENTRYPOINT [ "yarn", "run", "dev" ]
