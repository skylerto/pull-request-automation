#!/bin/bash
#
# The purpose of this script is to create a pull request based on environment variables, it does so by simply composing
# a few curl calls, a doing input validation.
#
# Required environment variables
#
# GITHUB_TOKEN: The PAT to use against github.
# REPOSITORY: The name of the repository in the format OWNER/REPO.
# PR_HEAD: The head of the pull request to be merged into the base.
#
# Optional environment variables:
#
# GITHUB_HOST: the github host to communicate with (defaults to https://api.github.com).
# PR_TITLE: The title of the pull request (defaults to "automated pull request").
# PR_BODY: The body of the pull request (defaults to "pull request created with automation").
# PR_BASE: The base branch to be merged into (defaults to main).
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

curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  "${GITHUB_HOST}/repos/${REPOSITORY}/pulls" \
  -d "{\"title\":\"${PR_TITLE}\",\"body\":\"${PR_BODY}\",\"head\":\"${PR_HEAD}\",\"base\":\"${PR_BASE}\"}"
