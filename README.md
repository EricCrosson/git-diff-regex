# git diff-regex

**git-diff-regex** is a git subcommand to diff and stage hunks by regex.

It helps you stage specific hunks from a set of unstaged changes, which in turn fosters atomic commits.

## Use

```
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
```
