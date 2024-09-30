#!/bin/sh -l

echo "::notice file=run_toolkit.sh,line=3::INPUTS_TOOLKIT_VERSION='$INPUTS_TOOLKIT_VERSION'"
echo "::notice file=run_toolkit.sh,line=4::INPUTS_TOOLKIT_PATH='$INPUTS_TOOLKIT_PATH'"
echo "::notice file=run_toolkit.sh,line=5::INPUTS_TOOLKIT_URL='$INPUTS_TOOLKIT_URL'"

# Check if the toolkit version is set
if [ -z "$INPUTS_TOOLKIT_VERSION" ]; then
	echo "::error file=run_toolkit.sh,line=9::The toolkit version is not set"
	exit 1
fi

# Check if the toolkit directory is set
if [ -z "$INPUTS_TOOLKIT_PATH" ]; then
	echo "::error file=run_toolkit.sh,line=15::The toolkit directory is not set"
	exit 1
fi

# Check if the toolkit URL is set
if [ -z "$INPUTS_TOOLKIT_URL" ]; then
	echo "::error file=run_toolkit.sh,line=21::The toolkit URL is not set"
	exit 1
fi

# Check if wget is installed
if ! command -v wget >/dev/null 2>&1; then
	echo "::error file=run_toolkit.sh,line=27::wget is not installed"
	exit 1
fi

# Create the toolkit directory
TOOLKIT_PATH="${GITHUB_WORKSPACE}/${INPUTS_TOOLKIT_PATH}"
if ! mkdir -p "$TOOLKIT_PATH"; then
	echo "::error file=run_toolkit.sh,line=34::Failed to create the toolkit directory"
	exit 1
fi

# Download the toolkit files
while read -r FILE; do
	FILENAME=$(basename "${FILE}")
	SOURCE_FILE="${INPUTS_TOOLKIT_URL}/${FILENAME}"
	TOOLKIT_FILE="${TOOLKIT_PATH}/${FILENAME}"
	if ! wget "${SOURCE_FILE}" -O "${TOOLKIT_FILE}"; then
		echo "::error file=run_toolkit.sh,line=44::Failed to download $SOURCE_FILE"
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

echo "::notice file=run_toolkit.sh,line=67::Downloaded toolkit files ${FILE_LIST} to ${TOOLKIT_PATH}"


# Parse Sarif files
echo "::notice file=run_toolkit.sh,line=3::INPUTS_TOOLKIT_VERSION='$INPUTS_TOOLKIT_VERSION'"
echo "::notice file=run_toolkit.sh,line=4::INPUTS_TOOLKIT_PATH='$INPUTS_TOOLKIT_PATH'"
echo "::notice file=run_toolkit.sh,line=5::INPUTS_TOOLKIT_URL='$INPUTS_TOOLKIT_URL'"
if "${TOOLKIT_PATH}/parse_sarif.sh" \
	"${REPOSITORY}" \
	"${SHA}" \
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

# create issues
if [ ! -z "${_SARIF2GHI_MOCKING_FOR_DEBUG_}" ]; then
	echo "Mocking create issues due to _SARIF2GHI_MOCKING_FOR_DEBUG_=${_SARIF2GHI_MOCKING_FOR_DEBUG_}"
fi
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

echo "time=$(date)" >>"$GITHUB_OUTPUT"
