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
  enforce_https: false,
  ignore_urls: [
    "https://bootcamp.berkeley.edu/blog/free-stem-resources-for-girls-and-women-in-data-science-machine-learning-and-ai/",
    "https://bootcamp.pe.gatech.edu/blog/how-to-empower-girls-in-stem/",
    /meetingplace.io/,
    /twitter.com/,
    "https://women-in-robotics.printify.me/product/2634428/women-in-robotics-day-2023-unisex-jersey-short-sleeve-tee",
    "https://women-in-robotics.printify.me/product/2634433/women-in-robotics-day-2023-womens-favorite-tee"
  ],
  ignore_status_codes: [
    403
  ],
  swap_urls: {
    "https://womeninrobotics.org/" => "/",
    "https://www.womeninrobotics.org/" => "/",
  }
}

HTMLProofer.check_directory('./_site', options).run
