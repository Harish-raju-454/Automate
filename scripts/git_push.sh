#!/bin/bash

echo "Adding and committing changes..."
git add .
git commit -m "Automated commit"

echo "Pushing to GitHub..."
git push origin main
