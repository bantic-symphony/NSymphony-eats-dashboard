#!/bin/bash

# NSymphony Eats Dashboard - Build & Deploy Script
# This script builds the Flutter web app and deploys it to Firebase Hosting

set -e  # Exit on any error

echo "🚀 Starting build and deploy process..."
echo ""

# Step 1: Build Flutter web app
echo "📦 Building Flutter web app..."
flutter build web --release

if [ $? -eq 0 ]; then
    echo "✅ Build completed successfully!"
    echo ""
else
    echo "❌ Build failed!"
    exit 1
fi

# Step 2: Deploy to Firebase Hosting
echo "🔥 Deploying to Firebase Hosting..."
firebase deploy --only hosting

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Deployment completed successfully!"
    echo ""
    echo "🌐 Your dashboard is live at:"
    echo "   https://nsymphony-eats-prod.web.app"
    echo "   https://nsymphony-eats-prod.firebaseapp.com"
    echo ""
else
    echo "❌ Deployment failed!"
    exit 1
fi
