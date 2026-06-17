#!/bin/bash
# Copies source to a temp dir outside Dropbox, renders there, then copies
# output back to docs/. Workaround for Dropbox eating intermediate HTML files.

QUARTO="/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto"
SITE_DIR="$(cd "$(dirname "$0")" && pwd)"
TMP_SRC=$(mktemp -d)
TMP_OUT=$(mktemp -d)

echo "Copying source to $TMP_SRC ..."
rsync -a \
  --exclude='.git' \
  --exclude='.Rproj.user' \
  --exclude='docs' \
  --exclude='_site' \
  --exclude='renv' \
  "$SITE_DIR/" "$TMP_SRC/"

echo "Rendering ..."
"$QUARTO" render "$TMP_SRC" --output-dir "$TMP_OUT"

if [ $? -eq 0 ]; then
  echo "Copying output to docs/ ..."
  rsync -a --delete "$TMP_OUT/" "$SITE_DIR/docs/"
  echo "Done. Site is in docs/"
else
  echo "Render failed — docs/ not updated."
fi

rm -rf "$TMP_SRC" "$TMP_OUT"
