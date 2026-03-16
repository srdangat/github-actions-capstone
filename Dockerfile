FROM node:22-alpine3.21 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY server.js ./

FROM node:22-alpine3.21
RUN apk update && apk upgrade --no-cache curl zlib
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./
RUN chown -R appuser:appgroup /app
USER appuser
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "server.js"]