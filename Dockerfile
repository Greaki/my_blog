FROM node:22 AS builder

WORKDIR /app
ENV NODE_ENV=production

# 设置 npm 镜像为淘宝源
ENV PNPM_REGISTRY=https://registry.npmmirror.com

RUN corepack enable

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --registry=https://registry.npmmirror.com --frozen-lockfile

COPY . .
RUN pnpm build


FROM node:22 AS runner

WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /app/.output ./.output
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
