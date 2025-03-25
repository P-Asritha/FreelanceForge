#!/bin/bash
echo "🚀 Deploying to Dev Environment..."

# Change to backend directory
cd api || exit 1

# Install production dependencies
npm install --omit=dev

# Start backend in the background
npm start &

echo "✅ Deployment to Dev Completed!"
