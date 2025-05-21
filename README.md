# Deploy Example Bash

This is an example of an automated deployment process. The key files are the following:
- `Dockerfile` - Builds an example image
- `.gitlab-ci.yml` - Contains the CI processes
- `make_modulefile.sh` - Pulls image and creates modulefile

# CI Process
The CI process is triggered whenever a new tag is created (`- if: $CI_COMMIT_TAG`). It could instead be whenever a new release is made, or any other desirable condition. You could even have the completion of another CI pipeline trigger this one.

### Build
Build the Dockerfile and push to the registry. This requires the following CI variables set:
- DOCKER_HUB_USERNAME
- DOCKER_HUB_PASSWORD

This step is set up for DockerHub, but there is no reason it can't be another configured registry.

### Deploy
This uses an SSH key to run a command as an authenticated user on Setonix. For information on SSH key set up for Gitlab, see the [Docs](https://docs.gitlab.com/ci/jobs/ssh_keys/#create-and-use-an-ssh-key). The user needs to have the public key in their .ssh directory on Setonix. For the sake of example, I have used my personal user here. For production, this should be a privileged user.

The SSH command runs the `make_modulefile.sh` script. This script does the following:
- Makes the module and software directories on Setonix if they do not exist
- Loads the singularity module and pulls the image from the registry
- Creates a Lua modulefile with the new tag version
