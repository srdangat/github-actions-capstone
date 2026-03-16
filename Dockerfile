# Stage 1: Build
FROM node:20-alpine3.21 AS builder

# Upgrade Alpine packages
RUN apk update && apk upgrade --no-cache

WORKDIR /app

# Copy package files and lockfile
COPY package*.json ./

# Install all dependencies (including dev)
RUN npm ci

# Copy app code
COPY server.js ./

# Stage 2: Runtime
FROM node:20-alpine3.21

# Upgrade runtime packages
RUN apk update && apk upgrade --no-cache

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy node_modules and app code from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./ 

# Set ownership
RUN chown -R appuser:appgroup /app

# Use non-root user
USER appuser

# Set production environment
ENV NODE_ENV=production

# Expose port
EXPOSE 3000

# Optional health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD curl -f http://localhost:3000/health || exit 1

# Start the app
CMD ["node", "server.js"]