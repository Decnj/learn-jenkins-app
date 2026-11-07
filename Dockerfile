FROM mcr.microsoft.com/playwright:v1.63.0-jammy

RUN npm install -g netlify-cli@20.1.1 serve

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl jq \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash