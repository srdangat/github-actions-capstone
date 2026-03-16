FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY server.js ./


FROM node:22-alpine
RUN apk add --no-cache curl
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./
RUN chown -R appuser:appgroup /app
USER appuser
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "server.js"]