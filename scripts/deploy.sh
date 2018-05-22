#!/usr/bin/env bash

# exit immediately if there is an error
set -e

# print shell input lines as they are read
set -v

readonly GIT_BRANCH="$(git symbolic-ref --short -q HEAD)"

# login to cloud foundry
# use the branch to decide between production or staging
if [[ "$GIT_BRANCH" = "master" ]]; then
  cf api $CF_API_PROD
  cf auth $CF_USERNAME "$CF_PASSWORD_PROD"
else
  cf api $CF_API_STAGING
  cf auth $CF_USERNAME "$CF_PASSWORD_STAGING"
fi
cf target -o $CF_ORG
cf target -s $CF_SPACE

# push our code to cloud foundry

# with downtime
cf push

# using zero-downtime-push https://github.com/contraband/autopilot
#cf zero-downtime-push spring-music -f manifest.yml
