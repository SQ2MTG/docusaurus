# Build the Docusaurus website from the monorepo
FROM node:24-bookworm AS builder

ENV COREPACK_HOME=/tmp/corepack
ENV CI=true

RUN corepack enable && corepack prepare pnpm@12.3.4 --activate

WORKDIR /app
COPY . .

RUN pnpm install --frozen-lockfile
RUN pnpm build:website

# Serve the generated static website with nginx
FROM nginx:1.29-alpine AS runner

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/website/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
