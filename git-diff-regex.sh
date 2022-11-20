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

set -o errexit
set -o nounset
set -o pipefail

# shellcheck disable=SC1091
source docopts.sh --auto "$@"
# shellcheck disable=SC2119
# docopt_print_ARGS

readonly regex="${ARGS[<regex>]}"
readonly stage_files="${ARGS[--add]}"

case "${stage_files}" in
    true)
        git diff -U0 \
            | grepdiff -E "${regex}" --output-matching=hunk \
            | git apply --cached --unidiff-zero
    ;;

    false)
        git diff -U0 \
            | grepdiff -E "${regex}" --output-matching=hunk \
            | "$(git var GIT_PAGER)"
    ;;
esac
