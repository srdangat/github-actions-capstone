# Stage 1: Build
FROM node:20-alpine3.21 AS builder

WORKDIR /app

# Copy package files and lockfile
COPY package*.json ./

# Install all dependencies (dev + prod)
RUN npm ci

# Copy app code
COPY server.js ./

# Stage 2: Runtime
FROM node:20-alpine3.21

# Install curl for healthcheck and upgrade packages
RUN apk update && apk upgrade --no-cache && apk add --no-cache curl

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy only production dependencies from builder
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

# Start the app
CMD ["node", "server.js"]