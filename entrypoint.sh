#!/bin/sh
# Auth
echo "$INPUT_SECRETS" >/secrets.json
gcloud auth activate-service-account --key-file=/secrets.json
rm /secrets.json

# Sync files to bucket
gsutil version
echo "Syncing bucket $BUCKET ..."
echo "Using Cache-Control:public, max-age=$INPUT_CACHECONTROL"

gsutil -m -h "Cache-Control:public, max-age=$INPUT_CACHECONTROL" rsync -r -c -d -x "$INPUT_EXCLUDE" /github/workspace gs://$INPUT_BUCKET/
echo "Done."
