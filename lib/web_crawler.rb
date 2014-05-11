require 'net/http'
require 'active_support'
require 'active_support/core_ext'
require 'uri'
require 'nokogiri'
require 'erb'

require_relative 'web_crawler/crawler'
require_relative 'web_crawler/link_tracker'
require_relative 'web_crawler/page_list'
require_relative 'web_crawler/page'
require_relative 'web_crawler/link'
require_relative 'web_crawler/site_mapper'

module WebCrawler
end
