#!/bin/bash
echo "🚀 Deploying to QA Environment..."

# Change to frontend directory
cd client || exit 1

# Force install production dependencies (fixes ERESOLVE)
npm install --omit=dev --legacy-peer-deps

# Start frontend in the background
npm run preview &

echo "✅ Deployment to QA Completed!"
