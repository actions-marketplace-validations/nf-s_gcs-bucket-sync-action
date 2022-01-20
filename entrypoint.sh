#!/bin/sh
# Auth
echo "$INPUT_SECRETS" >/secrets.json
gcloud auth activate-service-account --key-file=/secrets.json
rm /secrets.json

# Sync files to bucket
echo "Syncing bucket $BUCKET ..."
echo "Using Cache-Control:public, max-age=$INPUT_CACHECONTROL"

# If compressing files, add -z flag
[ "$INPUT_COMPRESS" = "true" ] &&
  gsutil -m rsync -r -c -d -z -h "Cache-Control:public, max-age=$INPUT_CACHECONTROL" -x "$INPUT_EXCLUDE" /github/workspace gs://$INPUT_BUCKET/ ||
  gsutil -m rsync -r -c -d -h "Cache-Control:public, max-age=$INPUT_CACHECONTROL" -x "$INPUT_EXCLUDE" /github/workspace gs://$INPUT_BUCKET/
echo "Done."
