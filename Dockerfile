# Install dependencies in a lightweight image
FROM node:18-alpine AS deps
WORKDIR /app

# Install system dependencies if needed
RUN apk add --no-cache libc6-compat

# Copy only the package files to install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy full project and build it
FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Run the app with a lightweight final image
FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=4001
ENV HOSTNAME=0.0.0.0

# Create a non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001
USER nextjs

# Copy standalone Next.js output
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Expose port for Traefik or NGINX reverse proxy
EXPOSE 4001

# Start the Next.js standalone app
CMD ["node", "server.js"]

