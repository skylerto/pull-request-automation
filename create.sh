#!/bin/bash
#
# The purpose of this script is to create a pull request based on environment variables, it does so by simply composing
# a few curl calls, a doing input validation.
#
# Required environment variables
#
# GITHUB_TOKEN: 
# REPOSITORY: 
# PR_HEAD: 
#
# Optional environment variables:
#
# GITHUB_HOST: the github host to communicate with (defaults to https://api.github.com).
# PR_TITLE: (defaults to "automated pull request").
# PR_BODY: (defaults to "pull request created with automation").
# PR_BASE: (defaults to main)
#

set -e
set -o pipefail

error_exit() {
  echo "${1}"
  exit 1
}

GITHUB_HOST="${GITHUB_HOST:-"https://api.github.com"}"
PR_TITLE="${PR_TITLE:-"automated pull request"}"
PR_BODY="${PR_BODY:-"pull request created with automation"}"
PR_BASE="${PR_BASE:-"main"}"

if [[ -z "${GITHUB_TOKEN}" ]]; then
  error_exit "GITHUB_TOKEN environment variable must be set"
fi

if [[ -z "${REPOSITORY}" ]]; then
  error_exit "REPOSITORY variable must be set in the format OWNER/REPO"
fi

if [[ -z "${PR_HEAD}" ]]; then
  error_exit "PR_HEAD variable must be set"
fi

# cat <<EOF
curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  "${GITHUB_HOST}/repos/${REPOSITORY}/pulls" \
  -d "{\"title\":\"${PR_TITLE}\",\"body\":\"${PR_BODY}\",\"head\":\"${PR_HEAD}\",\"base\":\"${PR_BASE}\"}"
# EOF
