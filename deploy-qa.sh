#!/bin/bash
echo "🚀 Deploying to QA Environment..."

# Change to frontend directory
cd client || exit 1

# Install only production dependencies
npm install --omit=dev

# Start the frontend (modify this if needed)
npm run preview

echo "✅ Deployment to QA Completed!"
