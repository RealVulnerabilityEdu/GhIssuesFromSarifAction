#!/bin/sh -l

echo "::notice file=download_toolkit.sh,line=3::INPUTS_TOOLKIT_VERSION='$INPUTS_TOOLKIT_VERSION'"
echo "::notice file=download_toolkit.sh,line=4::INPUTS_TOOLKIT_DIRECTORY='$INPUTS_TOOLKIT_DIRECTORY'"
echo "::notice file=download_toolkit.sh,line=5::INPUTS_TOOLKIT_URL='$INPUTS_TOOLKIT_URL'"

# Check if the toolkit version is set
if [ -z "$INPUTS_TOOLKIT_VERSION" ]; then
	echo "::error file=download_toolkit.sh,line=9::The toolkit version is not set"
	exit 1
fi

# Check if the toolkit directory is set
if [ -z "$INPUTS_TOOLKIT_DIRECTORY" ]; then
	echo "::error file=download_toolkit.sh,line=15::The toolkit directory is not set"
	exit 1
fi

# Check if the toolkit URL is set
if [ -z "$INPUTS_TOOLKIT_URL" ]; then
	echo "::error file=download_toolkit.sh,line=21::The toolkit URL is not set"
	exit 1
fi

# Check if wget is installed
if ! command -v wget >/dev/null 2>&1; then
	echo "::error file=download_toolkit.sh,line=27::wget is not installed"
	exit 1
fi

# Create the toolkit directory
TOOLKIT_DIRECTORY="${GITHUB_WORKSPACE}/${INPUTS_TOOLKIT_DIRECTORY}"
if ! mkdir -p "$TOOLKIT_DIRECTORY"; then
	echo "::error file=download_toolkit.sh,line=34::Failed to create the toolkit directory"
	exit 1
fi

while read -r FILE; do
	FILENAME=$(basename "${FILE}")
	SOURCE_FILE="${INPUTS_TOOLKIT_URL}/${FILENAME}"
	TOOLKIT_FILE="${TOOLKIT_DIRECTORY}/${FILENAME}"
	if ! wget "${SOURCE_FILE}" -O "${TOOLKIT_FILE}"; then
		echo "::error file=download_toolkit.sh,line=42::Failed to download $SOURCE_FILE"
		exit 1
	fi
done <<'EOT'
assemble_gh_issue_data.py
gh_issues.sh
parse_sarif.sh
EOT

FILE_LIST=""
for FILE in "${TOOLKIT_DIRECTORY}"/*; do
	FILE_LIST="${FILE_LIST}<${FILE}> "
done

{
	echo "toolkit-path=${TOOLKIT_DIRECTORY}"
	echo "file-list=${FILE_LIST}"
	echo "time=$(date)"
} >>"$GITHUB_OUTPUT"

echo "::notice file=download_toolkit.sh,line=63::Downloaded toolkit files ${FILE_LIST} to ${TOOLKIT_DIRECTORY}"
