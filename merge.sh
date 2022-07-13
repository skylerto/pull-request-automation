#!/bin/bash
#
# The purpose of this script is to merge a pull request based on environment variables, it does so by simply composing
# a few curl calls, a doing input validation.
#
# Required environment variables
#
# GITHUB_TOKEN: The PAT to use against github.
# REPOSITORY: The name of the repository in the format OWNER/REPO.
# PR_NUMBER: The number of the pull request to merge.
#
# Optional environment variables:
#
# GITHUB_HOST: the github host to communicate with (defaults to https://api.github.com).
#

set -e
set -o pipefail

error_exit() {
  echo "${1}"
  exit 1
}

GITHUB_HOST="${GITHUB_HOST:-"https://api.github.com"}"

if [[ -z "${GITHUB_TOKEN}" ]]; then
  error_exit "GITHUB_TOKEN environment variable must be set"
fi

if [[ -z "${REPOSITORY}" ]]; then
  error_exit "REPOSITORY variable must be set in the format OWNER/REPO"
fi

if [[ -z "${PR_NUMBER}" ]]; then
  error_exit "PR_NUMBER variable must be set"
fi

curl \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  "${GITHUB_HOST}/repos/${REPOSITORY}/pulls/${PR_NUMBER}/merge"
