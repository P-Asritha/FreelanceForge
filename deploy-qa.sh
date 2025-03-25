#!/bin/bash
echo "🚀 Deploying to QA Environment..."

# Change to frontend directory
cd client || exit 1

# Force install dependencies (temporary workaround)
npm install --omit=dev --legacy-peer-deps

# Start frontend preview
npx vite preview &

echo "✅ Deployment to QA Completed!"
