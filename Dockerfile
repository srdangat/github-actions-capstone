# Stage 1: Build
FROM node:20-alpine3.21 AS builder

# Set working directory
WORKDIR /app

# Install dependencies for building
COPY package*.json ./

# Clean install all deps (honors package-lock.json)
RUN npm ci

# Copy app code
COPY server.js ./

# Stage 2: Production Runtime
FROM node:20-alpine3.21

# Update OS packages and install curl for health checks
RUN apk update && apk upgrade --no-cache && apk add --no-cache curl

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy only production dependencies and app code
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./

# Set ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Set production environment
ENV NODE_ENV=production

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]