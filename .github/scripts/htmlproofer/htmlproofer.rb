#!/usr/local/bin/ruby
require 'html-proofer'

options = {
  parallel: { in_processes: 3 },
  typhoeus: {
    ssl_verifypeer: false,
    ssl_verifyhost: 0,
    timeout: 120,
    connecttimeout: 30,
    cookiefile: ".cookies",
    cookiejar: ".cookies"
  },
  ignore_urls: [
    "https://bootcamp.berkeley.edu/blog/free-stem-resources-for-girls-and-women-in-data-science-machine-learning-and-ai/",
    "https://bootcamp.pe.gatech.edu/blog/how-to-empower-girls-in-stem/",
    /meetingplace.io/,
    /twitter.com/
  ]
}

HTMLProofer.check_directory('./_site', options).run
