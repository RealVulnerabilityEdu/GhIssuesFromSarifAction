#!/bin/sh -l

git config --global --add safe.directory "$PWD"

echo "::notice file=run_toolkit.sh,line=5::INPUTS_TOOLKIT_VERSION='$INPUTS_TOOLKIT_VERSION'"
echo "::notice file=run_toolkit.sh,line=6::INPUTS_TOOLKIT_PATH='$INPUTS_TOOLKIT_PATH'"
echo "::notice file=run_toolkit.sh,line=7::INPUTS_TOOLKIT_URL='$INPUTS_TOOLKIT_URL'"
echo "::notice file=run_toolkit.sh,line=8::INPUTS_REPOSITORY='$INPUTS_REPOSITORY'"
echo "::notice file=run_toolkit.sh,line=9::INPUTS_SHA='$INPUTS_SHA'"
echo "::notice file=run_toolkit.sh,line=10::INPUTS_SARIF_DATA_PATH='$INPUTS_SARIF_DATA_PATH'"
echo "::notice file=run_toolkit.sh,line=11::INPUTS_QHELP_ROOT='$INPUTS_QHELP_ROOT'"
echo "::notice file=run_toolkit.sh,line=12::INPUTS_ISSUE_DATA_PATH='$INPUTS_ISSUE_DATA_PATH'"
echo "::notice file=run_toolkit.sh,line=13::INPUTS_ISSUE_BODY_TEMPLATE='$INPUTS_ISSUE_BODY_TEMPLATE'"

# Check if the toolkit version is set
if [ -z "$INPUTS_TOOLKIT_VERSION" ]; then
	echo "::error file=run_toolkit.sh,line=17::The toolkit version is not set"
	exit 1
fi

# Check if the toolkit directory is set
if [ -z "$INPUTS_TOOLKIT_PATH" ]; then
	echo "::error file=run_toolkit.sh,line=23::The toolkit directory is not set"
	exit 1
fi

# Check if the toolkit URL is set
if [ -z "$INPUTS_TOOLKIT_URL" ]; then
	echo "::error file=run_toolkit.sh,line=29::The toolkit URL is not set"
	exit 1
fi

# check if the repository URL is set
if [ -z "$INPUTS_REPOSITORY" ]; then
	echo "::error file=run_toolkit.sh,line=35::The repository (owner/repo_name) is not set"
	exit 1
fi

# check if the repository URL is set
if [ -z "$INPUTS_SHA" ]; then
	echo "::error file=run_toolkit.sh,line=41::The commit hash (SHA) is not set"
	exit 1
fi

# Check if wget is installed
if ! command -v wget >/dev/null 2>&1; then
	echo "::error file=run_toolkit.sh,line=47::wget is not installed"
	exit 1
fi

# Create the toolkit directory
TOOLKIT_PATH="${GITHUB_WORKSPACE}/${INPUTS_TOOLKIT_PATH}"
if ! mkdir -p "$TOOLKIT_PATH"; then
	echo "::error file=run_toolkit.sh,line=54::Failed to create the toolkit directory"
	exit 1
fi

# Download the toolkit files
while read -r FILE; do
	FILENAME=$(basename "${FILE}")
	SOURCE_FILE="${INPUTS_TOOLKIT_URL}/${INPUTS_TOOLKIT_VERSION}/${FILENAME}"
	TOOLKIT_FILE="${TOOLKIT_PATH}/${FILENAME}"
	if ! wget "${SOURCE_FILE}" -O "${TOOLKIT_FILE}"; then
		echo "::error file=run_toolkit.sh,line=64::Failed to download $SOURCE_FILE"
		exit 1
	fi
done <<'EOT'
assemble_gh_issue_data.py
gh_issues.sh
create_gh_issues.sh
parse_sarif.sh
EOT

chmod +x "${TOOLKIT_PATH}"/*.sh

FILE_LIST=""
for FILE in "${TOOLKIT_PATH}"/*; do
	FILE_LIST="${FILE_LIST}<${FILE}> "
done

{
	echo "toolkit-path=${TOOLKIT_PATH}"
	echo "file-list=${FILE_LIST}"
	echo "download-time=$(date)"
	echo "download-status=success"
} >>"$GITHUB_OUTPUT"

echo "::notice file=run_toolkit.sh,line=88::Downloaded toolkit files ${FILE_LIST} to ${TOOLKIT_PATH}"

# Parse Sarif files
echo "::notice file=run_toolkit.sh,line=91::runing '${TOOLKIT_PATH}/parse_sarif.sh'"
echo "::notice file=run_toolkit.sh,line=92::INPUTS_TOOLKIT_VERSION='$INPUTS_TOOLKIT_VERSION'"
echo "::notice file=run_toolkit.sh,line=93::INPUTS_TOOLKIT_PATH='$INPUTS_TOOLKIT_PATH'"
echo "::notice file=run_toolkit.sh,line=94::INPUTS_TOOLKIT_URL='$INPUTS_TOOLKIT_URL'"
# check if the issue body template is provided
if [ -z "$INPUTS_ISSUE_BODY_TEMPLATE" ]; then
	echo "::error file=run_toolkit.sh,line=97::The issue body template is not set"
	if "${TOOLKIT_PATH}/parse_sarif.sh" \
		"${INPUTS_REPOSITORY}" \
		"${INPUTS_SHA}" \
		"${INPUTS_SARIF_DATA_PATH}" \
		"${TOOLKIT_PATH}" \
		"${INPUTS_QHELP_ROOT}" \
		"${INPUTS_ISSUE_DATA_PATH}"; then
		ls -l "${INPUTS_ISSUE_DATA_PATH}"
		{
			echo "parse-sarif-time=$(date)"
			echo "parse-sarif-staus=success"
		} >>"$GITHUB_OUTPUT"
	else
		{
			echo "parse-sarif-time=$(date)"
			echo "parse-sarif-staus=failure"
		} >>"$GITHUB_OUTPUT"
	fi
else
	if "${TOOLKIT_PATH}/parse_sarif.sh" \
		"${INPUTS_REPOSITORY}" \
		"${INPUTS_SHA}" \
		"${INPUTS_SARIF_DATA_PATH}" \
		"${TOOLKIT_PATH}" \
		"${INPUTS_QHELP_ROOT}" \
		"${INPUTS_ISSUE_DATA_PATH}" \
		"${INPUTS_ISSUE_BODY_TEMPLATE}"; then
		ls -l "${INPUTS_ISSUE_DATA_PATH}"
		{
			echo "parse-sarif-time=$(date)"
			echo "parse-sarif-staus=success"
		} >>"$GITHUB_OUTPUT"
	else
		{
			echo "parse-sarif-time=$(date)"
			echo "parse-sarif-staus=failure"
		} >>"$GITHUB_OUTPUT"
	fi
fi
echo "::notice file=run_toolkit.sh,line=137::completed '${TOOLKIT_PATH}/parse_sarif.sh'"

# create issues
if [ -n "${_SARIF2GHI_MOCKING_FOR_DEBUG_}" ]; then
	echo "Mocking create issues due to _SARIF2GHI_MOCKING_FOR_DEBUG_=${_SARIF2GHI_MOCKING_FOR_DEBUG_}"
fi
echo "::notice file=run_toolkit.sh,line=143::runing '${TOOLKIT_PATH}/create_gh_issues.sh'"
echo "::notice file=run_toolkit.sh,line=144::TOOLKIT_PATH='$TOOLKIT_PATH'"
echo "::notice file=run_toolkit.sh,line=145::INPUTS_ISSUE_DATA_PATH='$INPUTS_ISSUE_DATA_PATH'"
if "${TOOLKIT_PATH}/create_gh_issues.sh" \
	"${INPUTS_ISSUE_DATA_PATH}"; then
	{
		echo "create-issue-time=$(date)"
		echo "create-issue-staus=success"
	} >>"$GITHUB_OUTPUT"
else
	{
		echo "create-issue-time=$(date)"
		echo "create-issue-staus=failure"
	} >>"$GITHUB_OUTPUT"
fi
echo "::notice file=run_toolkit.sh,line=158::completed '${TOOLKIT_PATH}/create_gh_issues.sh'"

echo "time=$(date)" >>"$GITHUB_OUTPUT"
echo "::notice file=run_toolkit.sh,line=161::all done"
