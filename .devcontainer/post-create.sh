#!/bin/sh

# Get the current ruby version ansd set .ruby-version
ruby_version=$(ruby -v | awk '{print $2}')
printf %s "$ruby_version" > .ruby-version
echo "Ruby version $ruby_version set in .ruby-version file"

# Install the version of Bundler.
if [ -f Gemfile.lock ] && grep "BUNDLED WITH" Gemfile.lock > /dev/null; then
    cat Gemfile.lock | tail -n 2 | grep -C2 "BUNDLED WITH" | tail -n 1 | xargs gem install bundler -v
fi

# If there's a Gemfile, then run `bundle install`
# It's assumed that the Gemfile will install Jekyll too
if [ -f Gemfile ]; then
    bundle install
fi
