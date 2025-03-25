#!/bin/bash
echo "🚀 Deploying to QA Environment..."

# Change to frontend directory
cd client || exit 1

# Install production dependencies
npm install --omit=dev

# Run frontend preview using globally installed Vite
vite preview &

echo "✅ Deployment to QA Completed!"
