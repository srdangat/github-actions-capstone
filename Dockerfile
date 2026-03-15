# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Update OS packages (fix zlib vulnerability)
RUN apk update && apk upgrade

COPY package*.json ./

# Install production dependencies
RUN npm ci --omit=dev

# Stage 2: Runtime
FROM node:20-alpine AS runtime

# Update OS packages again
RUN apk update && apk upgrade

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY server.js package.json ./

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 3000

CMD ["node", "server.js"]