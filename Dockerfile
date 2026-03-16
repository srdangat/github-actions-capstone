FROM node:22.17.1-bullseye-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY server.js ./

FROM node:22.17.1-bullseye-slim
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN addgroup --system appgroup && \
    adduser --system appuser --ingroup appgroup
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./
RUN chown -R appuser:appgroup /app
USER appuser
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "server.js"]