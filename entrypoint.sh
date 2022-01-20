#!/bin/sh
# Auth
echo "$INPUT_SECRETS" >/secrets.json
gcloud auth activate-service-account --key-file=/secrets.json
rm /secrets.json

# Sync files to bucket
echo "Syncing bucket $BUCKET ..."
echo "Using Cache-Control:public, max-age=$INPUT_CACHECONTROL"

([ "$INPUT_COMPRESS" = true ] && echo "Compressing files") || echo "Uploading uncompressed files"

# If compressing files, add -J flag
([ "$INPUT_COMPRESS" = true ] &&
  gsutil -m -h "Cache-Control:public, max-age=$INPUT_CACHECONTROL, content-encoding:gzip" rsync -r -c -d -J -x "$INPUT_EXCLUDE" /github/workspace gs://$INPUT_BUCKET/) ||
  gsutil -m -h "Cache-Control:public, max-age=$INPUT_CACHECONTROL" rsync -r -c -d -x "$INPUT_EXCLUDE" /github/workspace gs://$INPUT_BUCKET/
echo "Done."
