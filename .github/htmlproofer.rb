#!/usr/local/bin/ruby
require 'html-proofer'

options = {
  parallel: { in_processes: 3 },
  typhoeus: {
    ssl_verifypeer: false,
    ssl_verifyhost: 0,
    timeout: 120,
    connecttimeout: 30
  },
  log_level: "debug",
  ignore_urls: ["https://bootcamp.pe.gatech.edu/blog/how-to-empower-girls-in-stem/"]
}

HTMLProofer.check_directory('./_site', options).run
