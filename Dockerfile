# Start with fully-featured Node.js base image
FROM node:18.18.2 AS build

USER node
WORKDIR /home/node/mui-x-docs

COPY --chown=node:node . .

RUN yarn install

WORKDIR /home/node/mui-x-docs/docs

RUN yarn install

WORKDIR /home/node/mui-x-docs

# Build code
RUN yarn docs:build

# NGINX stage
FROM nginx:1.25.2-alpine

# Copy NGINX configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files from the previous stage to NGINX directory
COPY --from=build /home/node/mui-x-docs/docs/.next /usr/share/nginx/html

# Expose port 80 (default port for NGINX)
EXPOSE 80

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
