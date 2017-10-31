#!/bin/bash

set -eo pipefail

# Get the env
PANTHEON_ENV="$1"

# Merge the multidev for the PR into the dev environment
lando terminus -n multidev:merge-to-dev $PANTHEON_SITE_NAME.$PANTHEON_ENV --updatedb

# If there are any exported configuration files, then import them
if [ -f "config/system.site.yml" ] ; then
  lando terminus -n drush "$PANTHEON_SITE_NAME.dev" -- config-import --yes
fi

# Delete old multidev environments associated with a PR that has been
# merged or closed.
lando terminus -n multidev:delete $PANTHEON_SITE_NAME.$PANTHEON_ENV --delete-branch
