# packer_gcloud

## Overview
The container is used to build Packer images from a GitLab or GitHub runner (and others I'm sure).  I've used Hashis' base code and added in gcloud so that I could access Google secrets manager which is where I keep the service account password for vCenter in our DC to build VM templates.

## Usage

The following is an abbreviated version of the code in my `gitlab-ci.yaml` file that I'm using to pull the secret for vCenter.

```
.packer: &packer
  # Setup access to Google Secrets Manager
  # Pull the credentials to the Google project from the GitLab project variables
  - echo $GOOGLE_CREDENTIALS > google_credentials.json
  # Authenticate to Google using our new credentials file
  - gcloud auth activate-service-account --key-file=google_credentials.json
  # Set the project where all our secrets are saved
  - gcloud config set project my-gcp-project
  # Get our VMware password creds and write them to a file
  - gcloud secrets versions access latest --secret=vcenter-password > vcenter-password
  # Turn that file into an environment variable so we can use it later
  - export VCENTER_PASSWORD=$(cat vcenter-password)

template_vm:
  image: tigelane/packer_gcloud:latest
  script:
    - *packer
    - cd vm_template
    - packer build -force -var "vCenter_Password=$VCENTER_PASSWORD" -var-file vm-template.json vm-template-build.json
```