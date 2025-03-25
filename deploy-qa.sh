#!/bin/bash
echo "🚀 Deploying to QA Environment..."

# Change to frontend directory
cd client || exit 1

# Install production dependencies
npm install --omit=dev

# Start frontend in the background
npm run preview &

echo "✅ Deployment to QA Completed!"
