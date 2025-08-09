#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION?Set AWS_REGION in environment}"
: "${S3_BUCKET?Set S3_BUCKET in environment}"

BUILD_DIR="dist"

if [ ! -d "$BUILD_DIR" ]; then
  echo "Build directory '$BUILD_DIR' not found. Run 'npm run build' first."
  exit 1
fi

# Optional: set a custom cache policy via env or default
CACHE_MAX_AGE_SECONDS="${CACHE_MAX_AGE_SECONDS:-86400}"

# Sync files to S3 with correct cache headers and mime types
aws s3 sync "$BUILD_DIR/" "s3://$S3_BUCKET/" \
  --region "$AWS_REGION" \
  --delete \
  --cache-control "public, max-age=$CACHE_MAX_AGE_SECONDS" \
  --exclude "*.html"

# Upload HTML files with no-cache to avoid stale content
aws s3 sync "$BUILD_DIR/" "s3://$S3_BUCKET/" \
  --region "$AWS_REGION" \
  --delete \
  --cache-control "no-cache" \
  --exclude "*" \
  --include "*.html"

echo "Deployed to s3://$S3_BUCKET" 