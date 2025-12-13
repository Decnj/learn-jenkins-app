FROM node:18-alpine
COPY package.json package-lock.json .
RUN npm ci && npm run build
