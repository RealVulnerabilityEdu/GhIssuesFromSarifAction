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
if ! mkdir -p "$INPUTS_TOOLKIT_DIRECTORY"; then
	echo "::error file=download_toolkit.sh,line=33::Failed to create the toolkit directory"
	exit 1
fi

while read -r FILE; do
	FILENAME=$(basename "${FILE}")
	SOURCE_FILE="${INPUTS_TOOLKIT_URL}/${FILENAME}"
	TOOLKIT_FILE="${INPUTS_TOOLKIT_DIRECTORY}/${FILENAME}"
	if ! wget "${SOURCE_FILE}" -O "${TOOLKIT_FILE}"; then
		echo "::error file=download_toolkit.sh,line=39::Failed to download $SOURCE_FILE"
		exit 1
	fi
done <<'EOT'
assemble_gh_issue_data.py
gh_issues.sh
EOT

N_FILES=$(find "${INPUTS_TOOLKIT_DIRECTORY}" | wc -l)
echo "file_list=${N_FILES}" >>"$GITHUB_OUTPUT"
echo "time=$(date)" >>"$GITHUB_OUTPUT"
echo "::notice file=download_toolkit.sh,line=50::Downloaded ${N_FILES} toolkit files to ${INPUTS_TOOLKIT_DIRECTORY}"
