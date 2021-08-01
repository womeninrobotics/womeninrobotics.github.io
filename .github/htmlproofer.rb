#!/usr/local/bin/ruby
require 'html-proofer'

options = {
  assume_extension: true,
  check_favicon: true,
  check_opengraph: false,
  check_html: true,
  check_img_http: true,
  empty_alt_ignore: false,
  enforce_https: true,
  internal_domains: ['womeninrobotics.org', 'www.womeninrobotics.org'],
  parallel: { in_processes: 3 },
  typhoeus: {
    ssl_verifypeer: false,
    ssl_verifyhost: 0,
    timeout: 120,
    connecttimeout: 30
  },
}

HTMLProofer.check_directory('./_site', options).run
