# Stage 1: Build
FROM node:20.8.1-alpine AS builder
RUN apk update && apk upgrade --no-cache
WORKDIR /app
COPY package-lock.json package.json ./
RUN npm ci --only=production

# Stage 2: Runtime
FROM node:20.8.1-alpine AS runtime
RUN apk update && apk upgrade --no-cache
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY server.js package.json ./
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 3000
CMD ["node", "server.js"]