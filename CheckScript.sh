#!/bin/bash
 
# Parse command-line arguments for -user and -wp flags and their values.
for arg in "$@"; do
    shift
    case "$arg" in
        "-wp") WORKSPACE_PATH="$1"; shift;;
    esac
done
 
# Check if the provided path exists and is a directory
if [ ! -d "$WORKSPACE_PATH" ]; then
    echo "The provided workspace path is not valid."
    exit 1
fi

# Ensure the workspace path ends with a slash
WORKSPACE_PATH="${WORKSPACE_PATH%/}/*"
 
# Initialize counters for parsed and total repositories
PARSED_REPOSITORIES=0
NBM_OF_REPOSITORIES=0
 
# Iterate through each subdirectory (assumed to be Git repositories)
for REPO in $WORKSPACE_PATH; do
  PARSED_REPOSITORIES=$((PARSED_REPOSITORIES+1))
  # Check if the repository directory exists
  if [ -d "$REPO/.git" ]; then
    echo "Updating repository: $REPO"
    
    cd $REPO
    
    # Run git pull and display the output
    git pull $REPO 2>&1 | while read REPO; do
      echo $REPO
    done
    
    NBM_OF_REPOSITORIES=$((NBM_OF_REPOSITORIES+1))
  else 
    echo "Repository $REPO does not exist."
  fi
  done 
  
# Echo the final message only if updates were performed
if [ $PARSED_REPOSITORIES == $NBM_OF_REPOSITORIES ]; then
  echo "All repositories have been accessed." 
fi

