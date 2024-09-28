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
if ! command -v wget > /dev/null 2>&1; then
    echo "::error file=download_toolkit.sh,line=27::wget is not installed"
    exit 1
fi

# Create the toolkit directory
if ! mkdir -p "$INPUTS_TOOLKIT_DIRECTORY"; then
    echo "::error file=download_toolkit.sh,line=33::Failed to create the toolkit directory"
    exit 1
fi


# mkdir -p _real_word_vul_edu_
# wget http://www.sci.brooklyn.cuny.edu/~chen/uploads/research/ghissues/assemble_gh_issue_data.py -O _real_word_vul_edu_/assemble_gh_issue_data.py
# wget http://www.sci.brooklyn.cuny.edu/~chen/uploads/research/ghissues/gh_issues.sh -O _real_word_vul_edu_/gh_issues.sh
# pwd
# ls _real_word_vul_edu_
