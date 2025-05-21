#!/bin/bash
set -e

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 BASE_DIR REMOTE_IMAGE VERSION"
    echo "E.g. $0 /software/projects/username docker://username/hello-world 0.0.1"
    echo "Pulls an image from a remote registry. Then creates a new modulefile for it."
    exit 1
fi

BASE_DIR=$1
REMOTE_IMAGE=$2
VERSION=$3

MODULE_FILE_PATH="$BASE_DIR/modulefiles/hello-world/$VERSION.lua"
SOFTWARE_DIR="$BASE_DIR/hello-world/$VERSION"

mkdir -p $BASE_DIR/modulefiles/hello-world
mkdir -p $SOFTWARE_DIR

module load singularity/4.1.0-slurm

echo "Pulling image from $REMOTE_IMAGE:$VERSION to $SOFTWARE_DIR/hello-world"
singularity pull -F $SOFTWARE_DIR/hello-world $REMOTE_IMAGE:$VERSION


# Basic templating of the module file - saves to MODULE_FILE_PATH
echo "Creating module file at $MODULE_FILE_PATH"
cat > "$MODULE_FILE_PATH" << EOF
help([[
This module loads hello-world v$VERSION
]])

whatis("Name: Hello World")
whatis("Version: $VERSION")
whatis("Description: Hello World software kit")

setenv("HELLO_WORLD_HOME", "$SOFTWARE_DIR")
setenv("HELLO_WORLD_VERSION", "$VERSION")

prepend_path("PATH", "$SOFTWARE_DIR")
EOF
echo "Done"
