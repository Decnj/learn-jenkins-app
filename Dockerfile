FROM mcr.microsoft.com/playwright:v1.63.0-jammy

RUN npm install -g netlify-cli@20.1.1 serve

RUN npm install -g node-jq