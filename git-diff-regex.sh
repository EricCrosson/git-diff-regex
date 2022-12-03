#!/usr/bin/env bash
#
# Diff and stage hunks by regex.
#
# Usage:
#  git-diff-regex [-a] <regex>
#
# Options:
#   -a --add    Add matches to the staging area
#   <regex>     Regex used to select hunks from the working tree
#
# @example
# git diff-regex foobar
#
# @example
# git diff-regex --add foobar

set -o errexit
set -o nounset
set -o pipefail

usage() {
  cat <<EOF

Usage:
 git-diff-regex [-a] <regex>

Options:
  -a --add    Add matches to the staging area
  <regex>     Regex used to select hunks from the working tree
EOF
}

# Parse arguments
stage_files=false
regex=""

while [ "${1:-}" != "" ]; do
  case "$1" in
  -a | --add)
    stage_files=true
    shift # past arg
    ;;
  -h | --help)
    usage
    exit 1
    ;;
  *)
    regex="$1"
    shift # past value
    ;;
  esac
done

# Validate arguments
validation_errors=false

if [ -z "$regex" ]; then
  echo >&2 "Error: must supply <regex>"
  validation_errors=true
fi

if [ "$validation_errors" == true ]; then
  usage
  exit 1
fi

main() {
  case "${stage_files}" in
  true)
    git diff -U0 |
      grepdiff -E "${regex}" --output-matching=hunk |
      git apply --cached --unidiff-zero
    ;;

  false)
    git diff -U0 |
      grepdiff -E "${regex}" --output-matching=hunk |
      "$(git var GIT_PAGER)"
    ;;
  esac
}

main
