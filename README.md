Killer Drupal 8 Workflow for Pantheon
=====================================

This project is meant to be forked and used as an easy-to-get-going start state for an awesome dev workflow that includes:

1. Canonical upstream repo on [GitHub](http://github.com)
2. Local development and tooling with [Lando](http://docs.devwithlando.io)
3. Hosting on [Pantheon](http://pantheon.io)
4. Automatic manual QA environments via [Pantheon multi-dev](https://pantheon.io/docs/multidev/)
6. Merge-to-master deploy-to-pantheon-dev pipeline
7. Automated code linting, unit testing and behat testing with [Travis](https://travis-ci.org/)

What You'll Need
----------------

Before you kick off you'll need to make sure you have a few things:

1. A GitHub account, ideally with your SSH key(s) added
2. A Pantheon account with a [Machine Token](https://pantheon.io/docs/machine-tokens/)
3. A Travis CI account
4. [Lando installed](https://docs.devwithlando.io/installation/installing.html)
5. [Git installed](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)*
6. (Optional) [ZenHub](https://www.zenhub.com/) for Kanban style issue management in GitHub

It is also definitely worth reading about the upstream [starter kit](https://github.com/pantheon-systems/example-drops-8-composer).

* If you are using lando you can forgo the git installation (this is potentially useful for Windows devs) by uncommenting git in the tooling section of your .lando.yml. If you do this you'll need to run `lando git` instead of `git` for all the examples below.

Getting Started
---------------

### 1. Setup Pantheon

Login to Pantheon and create a new D8 project through the user interface. After naming your site and completing the spin up visit your site and go through the Drupal installation process to get your DB dialed in.

### 2. Setup GitHub

Visit [this start state](https://github.com/lando/lando-pantheon-ci-workflow-example) on GitHub and fork the project to the org or account of your choosing. Then `git clone` the repo and `cd` into it.

```bash
git clone https://github.com/lando/lando-pantheon-ci-workflow-example mysite
cd mysite
```

### 3. Setup Local Lando and Connect to Pantheon

Let's start by spinning up a local copy of our Pantheon site with Lando.

This should spin up the services to run your app (eg `php`, `nginx`, `mariabdb`, `redis`, `solr`, `varnish`) and the tools you need to start development (eg `terminus`, `drush`, `composer`, `drupal console`). This will install a bunch of deps the first time you run it but when it is done you should end up with some URLs you can use to visit your local site.

```bash
# Connect to pantheon
cd /path/to/my/repo
lando init --recipe=pantheon

# Start the app
lando start

# Pull the database and files
# Run lando pull -- -h for options
land pull
```

If you are interested in tweaking your setup check out the comments in your app's `.lando.yml`. Or you can augment your Lando spin up with additional services or tools by checking out the [advanced Lando docs](https://docs.devwithlando.io/tutorials/setup-additional-services.html).

### 4. Setup Travis CI

You will want to start by doing Steps 1 and 2 in the Travis [getting started docs](https://docs.travis-ci.com/user/getting-started/). We already have a pre-baked `.travis.yml` file for you so you don't need to worry about that unless you want to tweak it.

Finally, set your Pantheon machine token and site machine name as environment variables [via the Travis UI](https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings).

```
PANTHEON_MACHINE_TOKEN=TOKEN_YOU_GENERATED
PANTHEON_SITE_NAME=PANTHEON_SITE_NAME
```

Trying Things Out
-----------------

Let's go through a [GitHub flow](https://guides.github.com/introduction/flow/) example!

This is a trivial example which deploys all merges into the `master` branch to the Pantheon dev environment.

### 1. Set up a topic branch

```bash
# Go into the repo
cd /path/to/my/github/repo

# Checkout master and get the latest and greatest
git checkout master
git pull origin master

# Spin up a well named topic branch eg ISSUE_NUMBER-DESCRIPTION
git checkout -b 1-fixes-that-thing
```

### 2. Do the dev, commit and push the codes

```
# Do some awesome dev

# Git commit with a message that matches the issue number
git add -A
git commit -m "#1: Describes what i did"

# Push the branch to GitHub
git push origin 1-fixes-that-thing
```

* Check out the Lando Reference section below for some tips on how to run tests before you push. This can save a lot of time and reduce the potential shame you feel for failing the automated QA

### 3. Open a PR and do manual and automated testing

Begin by [opening a pull request](https://help.github.com/articles/creating-a-pull-request/). This will trigger the spin up of a QA environment for manual testing and a Travis build for automated testing.

Here is an example PR with:

* [PR on GitHub](https://github.com/thinktandem/platformsh-example-drupal8/pull/2)
* [QA Environment on Platform.sh](http://pr-2-tcs3n7y-2a6htdqmmpchu.us.platform.sh/)
* [Travis PR Build](https://travis-ci.org/thinktandem/platformsh-example-drupal8/builds/289355899?utm_source=github_status&utm_medium=notification)

### 4. Deploy

When you are statisifed with the above, and any additional QA steps like manual code review you can [merge the pull request](https://help.github.com/articles/merging-a-pull-request/). This will deploy the feature to production.

Lando Reference
---------------

You should definitely check out the [Lando Pantheon docs](https://docs.devwithlando.io/tutorials/pantheon.html) for a full sweep on its capabilities but here are some helpers for this particular config. **YOU PROBABLY WANT TO LANDO START YOUR APP BEFORE YOU DO MOST OF THESE THINGS.**

Unless otherwise indicated these should all be run from your repo root (eg the directory that contains the `.lando.yml` for your site).

### Generic Ccommands

```bash
# List all available lando commands for this app
lando

# Start my site
lando start

# Stop my site
lando stop

# Restart my site
lando restart

# Get important connection info
lando info

# Other helpful things
# Rebuild all containers and build process steps
lando rebuild
# Destroy the containers and tools for this app
lando destroy
# Get info on lando service logs
lando logs
# Get a publically accessible URL. Run lando info to get the proper localhost address
lando share -u http://localhost:32813
# "SSH" into the appserver
lando ssh

# Run help to get more info
lando ssh -- --help
```

### Development commands

```bash
# Run composer things
lando composer install
lando composer update

# Run php things
lando php -v
lando php -i

# Run drush commands
# replace web if you've moved your webroot to a difference subdirectory
cd web
lando drush status
lando drush cr

# Run drupal console commands
# replace web if you've moved your webroot to a difference subdirectory
cd web
lando drupal
```

### Testing commands

```bash
# Lint code
lando phplint

# Run phpcs commands
lando phpcs
# Check drupal code standards
lando phpcs --config-set installed_paths /app/vendor/drupal/coder/coder_sniffer
lando phpcs -n --report=full --standard=Drupal --ignore=*.tpl.php --extensions=install,module,php,inc web/modules web/themes web/profiles

# Run phpunit commands
# replace web if you've moved your webroot to a difference subdirectory
cd web
lando phpunit
# Run some phpunit tests
lando phpunit -c core --testsuite unit --exclude-group Composer

# Run behat commands
lando behat
# Run some behat tests
lando behat --config=/app/tests/behat-pantheon.yml
```

### Pantheon commands

```bash
# List terminus commands
lando terminus list

# Pull stuff from pantheon
# NOT THE BEST IDEA IN THIS SETUP
lando pull

# Push stuff to pantheon
# NOT THE BEST IDEA IN THIS SETUP
lando push

# Switch multidev env
# NOT THE BEST IDEA IN THIS SETUP
lando switch <ENV>

# Advanced commands
# Redis CLI
lando redis-cli
# Varnish admin
lando varnishadm
```
