FROM node:18.10.0-alpine3.15
WORKDIR /app

# Install bash
RUN apk --no-cache add bash

# Copy all needed files
COPY . .

# Install needed pacakges
RUN npm install

# Install PM2
RUN npm install pm2 -g

# Run!
ENTRYPOINT ["/app/run.sh"]
