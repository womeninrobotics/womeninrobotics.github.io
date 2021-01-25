#!/bin/bash
# BANDAID: http-status-ignore checks added due to rate limiting on social sites
bundle exec htmlproofer --http-status-ignore 400,999 ./_site
