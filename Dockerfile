FROM node:22 AS builder

WORKDIR /app
ENV NODE_ENV=production

# 使用国内 apt 源
RUN sed -i 's|http://deb.debian.org/debian|http://mirrors.aliyun.com/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://mirrors.aliyun.com/debian-security|g' /etc/apt/sources.list

# 安装构建工具和依赖
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

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
