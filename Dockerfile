FROM node:18.10.0-alpine3.15
WORKDIR /app

# Install bash
RUN apk --no-cache add bash git

# Copy package.json
COPY package.json .

# Install needed pacakges
RUN npm install

# Install PM2
RUN npm install pm2 -g

# Copy all needed files
COPY . .

# Run!
ENTRYPOINT ["/app/run.sh"]
