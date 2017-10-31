#!/bin/bash

set -eo pipefail

BRANCH=$(echo $TRAVIS_PULL_REQUEST_BRANCH | grep -v '^\(master\|[0-9]\+.x\)$')
PR_ENV=${BRANCH:+pr-$BRANCH}
DEFAULT_ENV=$(echo ${PR_ENV:-$TRAVIS_PULL_REQUEST_BRANCH} | tr '[:upper:]' '[:lower:]' | sed 's/[^0-9a-z-]//g' | cut -c -11 | sed 's/-$//')

# Merge the multidev for the PR into the dev environment
#lando terminus -n build:env:merge "$TERMINUS_SITE.$TERMINUS_ENV" --yes

# Run updatedb on the dev environment
# lando terminus -n drush $TERMINUS_SITE.dev -- updatedb --yes

# If there are any exported configuration files, then import them
if [ -f "config/system.site.yml" ] ; then
  # lando terminus -n drush "$TERMINUS_SITE.dev" -- config-import --yes
fi

# Delete old multidev environments associated with a PR that has been
# merged or closed.
# lando terminus -n build:env:delete:pr "$TERMINUS_SITE" --yes
