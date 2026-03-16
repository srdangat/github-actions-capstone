# Stage 1: Build
FROM node:22.4.0-alpine3.22 AS builder
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy app source
COPY server.js ./

# Stage 2: Production
FROM node:22.4.0-alpine3.22

# Install runtime dependencies only
RUN apk add --no-cache curl zlib

# Add non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy built node_modules and app code
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./

# Fix ownership and switch user
RUN chown -R appuser:appgroup /app
USER appuser

# Environment and port
ENV NODE_ENV=production
EXPOSE 3000

# Start app
CMD ["node", "server.js"]