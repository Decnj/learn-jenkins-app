FROM mcr.microsoft.com/playwright:v1.63.0-jammy

RUN npm install -g netlify-cli@20.1.1 serve

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl jq unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install \
    && rm -rf awscliv2.zip aws