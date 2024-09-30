#!/bin/sh -l

if "${{github.workspace}}/${{inputs.toolkit-path}}/parse_sarif.sh" \
    "${{github.repository}}" \
    "${{github.sha}}" \
    "${{inputs.sarif-data-path}}" \
    "${{inputs.toolkit-path}}" \
    "${{inputs.qhelp-root}}" \
    "${{inputs.issue-data-path}}"; then
    ls -l "${{inputs.issue-data-path}}"
    echo "::set-output name=status::success"
else
    echo "::set-output name=status::failure"
fi