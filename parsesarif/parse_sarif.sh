#!/bin/sh -l

if [ $# -ne 6 ]; then
    echo "Usage: $0 <repository> <sha> <sarif-data-path> <toolkit-path> <qhelp-root> <issue-data-path>"
    exit 1
fi

REPOSITORY=$1
SHA=$2
SARIF_DATA_PATH=$3
TOOLKIT_PATH=$4
QHELP_ROOT=$5
ISSUE_DATA_PATH=$6


if "${TOOLKIT_PATH}/parse_sarif.sh" \
    "${REPOSITORY}" \
    "${SHA}" \
    "${SARIF_DATA_PATH}" \
    "${TOOLKIT_PATH}" \
    "${QHELP_ROOT}" \
    "${ISSUE_DATA_PATH}"; then
    ls -l "${ISSUE_DATA_PATH}"
    echo "::set-output name=status::success"
else
    echo "::set-output name=status::failure"
fi