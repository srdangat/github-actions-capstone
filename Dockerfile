# Stage 1 — Build
FROM node:22-alpine3.23 AS builder
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy source
COPY server.js ./

# Stage 2 — Runtime
FROM node:22-alpine3.23

# Install runtime dependencies
RUN apk add --no-cache curl zlib

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./

RUN chown -R appuser:appgroup /app
USER appuser

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "server.js"]