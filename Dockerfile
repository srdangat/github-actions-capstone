# Stage 1: Build
FROM node:20-alpine3.21 AS builder

# Upgrade Alpine packages to reduce OS vulnerabilities
RUN apk update && apk upgrade --no-cache

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dev & prod dependencies (resolutions will be applied)
RUN npm ci

# Copy application code
COPY server.js ./

# Stage 2: Runtime
FROM node:20-alpine3.21

# Upgrade Alpine packages in runtime stage
RUN apk update && apk upgrade --no-cache

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./ 

# Set permissions
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

EXPOSE 3000

CMD ["node", "server.js"]