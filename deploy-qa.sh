#!/bin/bash
echo "🚀 Deploying to QA Environment..."

# Navigate to frontend directory
cd client || { echo "Frontend directory not found!"; exit 1; }

# Install production dependencies with legacy-peer-deps (to fix version issues)
echo "📦 Installing frontend dependencies..."
npm install --omit=dev --legacy-peer-deps || { echo "Frontend dependency installation failed!"; exit 1; }

# Use PM2 to run frontend preview
echo "🔄 Starting frontend preview..."
pm2 start npm --name "frontend-preview" -- run "vite preview" || { echo "Failed to start frontend with PM2!"; exit 1; }

echo "✅ Deployment to QA Completed!"
