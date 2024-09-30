#!/bin/sh -l

if [ $# -ne 2 ]; then
    echo "Usage: $0 <toolkit-path> <issue-data-path>"
    exit 1
fi

TOOLKIT_PATH=$1
ISSUE_DATA_PATH=$2

if "${TOOLKIT_PATH}/create_gh_issues.sh" \
    "${ISSUE_DATA_PATH}"; then
    echo "::set-output name=status::success"
else
    echo "::set-output name=status::failure"
fi