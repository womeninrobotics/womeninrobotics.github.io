#!/bin/bash
# BANDAID: http-status-ignore checks added due to rate limiting on social sites
bundle exec htmlproofer --url-ignore "/www.twitter.com/,/www.linkedin.com/" ./_site
