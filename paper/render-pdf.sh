#!/usr/bin/env bash
# Build paper.pdf from paper.md using the JOSS (openjournals/whedon) LaTeX template.
# Matches the pandoc invocation in whedon/lib/whedon/compilers.rb (pdf_from_markdown).
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "pandoc is required. Install pandoc (https://pandoc.org/)." >&2
  exit 1
fi

if ! command -v xelatex >/dev/null 2>&1; then
  echo "xelatex is required (TeX Live, MacTeX, or TinyTeX)." >&2
  exit 1
fi

# Prefer TinyTeX when present (JOSS template needs packages beyond BasicTeX).
if [[ -d "${HOME}/Library/TinyTeX/bin/universal-darwin" ]]; then
  export PATH="${HOME}/Library/TinyTeX/bin/universal-darwin:${PATH}"
fi

logo_path="$(cd "${root}/paper/resources/joss" && pwd)/logo.png"
aas_logo_path="$(cd "${root}/paper/resources/joss" && pwd)/aas-logo.png"
template="${root}/paper/resources/joss/latex.template"
csl="${root}/paper/resources/joss/apa.csl"

pandoc \
  -o paper.pdf \
  -V geometry:margin=1in \
  -V graphics=true \
  -V link-citations=true \
  -V "logo_path=${logo_path}" \
  -V "aas_logo_path=${aas_logo_path}" \
  --pdf-engine=xelatex \
  --citeproc \
  --from markdown \
  --csl="${csl}" \
  --template="${template}" \
  --include-in-header=paper/resources/citeproc-fix.tex \
  --metadata-file=paper/metadata-preview.yaml \
  paper.md \
  "$@"

echo "Wrote ${root}/paper.pdf"
