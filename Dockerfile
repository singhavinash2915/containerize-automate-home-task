# Use Node.js 20 LTS as base image (>= 18)
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy TypeScript configuration and source code
COPY tsconfig.json ./
COPY src/ ./src/

# Install dev dependencies for build
RUN npm install --only=development

# Build the TypeScript code
RUN npm run build

# Remove dev dependencies to reduce image size
RUN npm prune --production

# Create logs directory
RUN mkdir -p logs

# Copy environment example (user can override with volume mount or env vars)
COPY .env_example .env

# Expose port (assuming the app runs on port 3000, adjust if needed)
EXPOSE 3000

# Start the application
CMD ["npm", "start"]