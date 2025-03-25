#!/bin/bash
echo "🚀 Deploying to Dev Environment..."

# Change to backend directory
cd api || exit 1

# Install only production dependencies
npm install --omit=dev

# Start the backend (modify this if needed)
npm start

echo "✅ Deployment to Dev Completed!"
