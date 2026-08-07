#!/bin/sh
# Substitutes CRUSH_NAME into index.html and writes the result to dist/.
# Netlify runs this at deploy time (see netlify.toml) and publishes dist/,
# so her real name never has to be committed to the repo.
#
# Local preview:  CRUSH_NAME="Her Name" sh build.sh && open dist/index.html

set -eu

if [ -z "${CRUSH_NAME:-}" ]; then
  echo "ERROR: CRUSH_NAME is not set." >&2
  echo "  Netlify: Site configuration -> Environment variables -> add CRUSH_NAME" >&2
  echo "  Local:   CRUSH_NAME=\"Her Name\" sh build.sh" >&2
  exit 1
fi

mkdir -p dist

# Use awk with a literal (non-regex) replacement so names with punctuation
# or accents can't be mangled the way a sed pattern would.
awk -v name="$CRUSH_NAME" '
  {
    while (i = index($0, "__CRUSH_NAME__")) {
      $0 = substr($0, 1, i - 1) name substr($0, i + length("__CRUSH_NAME__"))
    }
    print
  }
' index.html > dist/index.html

echo "Built dist/index.html for $CRUSH_NAME"
