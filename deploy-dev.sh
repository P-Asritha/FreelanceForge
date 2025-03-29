#!/bin/bash
echo "🚀 Deploying to Dev Environment..."

# Navigate to backend directory
cd api || { echo "Backend directory not found!"; exit 1; }

# Install production dependencies
echo "📦 Installing production dependencies..."
npm install --omit=dev || { echo "Backend dependency installation failed!"; exit 1; }

# Use PM2 to restart backend app
echo "🔄 Restarting backend application..."
pm2 restart ecosystem.config.js || { echo "Failed to restart backend with PM2!"; exit 1; }

echo "✅ Deployment to Dev Completed!"
