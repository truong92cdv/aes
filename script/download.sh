#!/bin/bash

# Script to download folder from GitHub to local directory
# Usage: ./download.sh <github_repo_url> <local_directory>

# Check number of parameters
if [ $# -ne 2 ]; then
    echo "Usage: $0 <github_repo_url> <local_directory>"
    echo "Example: $0 https://github.com/truong92cdv/aes/rtl ./my_rtl"
    echo ""
    echo "Parameters:"
    echo "  github_repo_url: URL of GitHub folder (example: https://github.com/user/repo/trunk/folder)"
    echo "  local_directory: Target directory on local machine"
    exit 1
fi

GITHUB_URL="$1"
LOCAL_DIR="$2"

# Extract information from GitHub URL and auto-adjust
if [[ "$GITHUB_URL" =~ https://github.com/([^/]+)/([^/]+)/([^/]+)/([^/]+) ]]; then
    # Format: https://github.com/user/repo/branch/folder
    USER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    BRANCH="${BASH_REMATCH[3]}"
    FOLDER="${BASH_REMATCH[4]}"
elif [[ "$GITHUB_URL" =~ https://github.com/([^/]+)/([^/]+)/([^/]+) ]]; then
    # Format: https://github.com/user/repo/folder (auto-detect branch as main)
    USER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    FOLDER="${BASH_REMATCH[3]}"
    BRANCH="main"
    echo "Note: Branch not specified, using 'main' as default"
elif [[ "$GITHUB_URL" =~ https://github.com/([^/]+)/([^/]+) ]]; then
    # Format: https://github.com/user/repo (auto-detect branch as main, folder as root)
    USER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    BRANCH="main"
    FOLDER=""
    echo "Note: Branch and folder not specified, using 'main' branch and root folder"
else
    echo "Error: Invalid GitHub URL format!"
    echo "Supported formats:"
    echo "  https://github.com/user/repo/branch/folder"
    echo "  https://github.com/user/repo/folder"
    echo "  https://github.com/user/repo"
    exit 1
fi

echo "Repository information:"
echo "  User: $USER"
echo "  Repository: $REPO"
echo "  Branch: $BRANCH"
if [ ! -z "$FOLDER" ]; then
    echo "  Folder: $FOLDER"
else
    echo "  Folder: root (entire repository)"
fi
echo ""

if [ ! -z "$FOLDER" ]; then
    echo "Downloading folder '$FOLDER' from $USER/$REPO (branch: $BRANCH)..."
else
    echo "Downloading entire repository $USER/$REPO (branch: $BRANCH)..."
fi
echo "Saving to directory: $LOCAL_DIR"
echo ""

# Create target directory if it doesn't exist
mkdir -p "$LOCAL_DIR"

# Get file list from GitHub API and download each file
echo "Getting file list..."
if [ ! -z "$FOLDER" ]; then
    # Download specific folder
    API_URL="https://api.github.com/repos/$USER/$REPO/contents/$FOLDER?ref=$BRANCH"
    echo "API URL: $API_URL"
else
    # Download entire repository
    API_URL="https://api.github.com/repos/$USER/$REPO/contents?ref=$BRANCH"
    echo "API URL: $API_URL"
fi

curl -s "$API_URL" | \
grep '"download_url"' | \
sed 's/.*"download_url": "\([^"]*\)".*/\1/' | \
while read url; do
    if [ ! -z "$url" ]; then
        filename=$(basename "$url")
        echo "Downloading: $filename"
        curl -L -o "$LOCAL_DIR/$filename" "$url"
        if [ $? -eq 0 ]; then
            echo "  ✓ Completed: $filename"
        else
            echo "  ✗ Error downloading: $filename"
        fi
    fi
done

echo ""
echo "Completed! All files have been downloaded to directory $LOCAL_DIR/"
echo "Downloaded file list:"
ls -la "$LOCAL_DIR/"
