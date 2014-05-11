require 'optparse'
require 'logger'

module WebCrawler
  # CommandLine
  #
  # This class is the responsible for creating the site map through command line.
  # It should receive a array of arguments/options and print (or write to a file
  # the output of the crawling as a site map page.
  #
  class CommandLine

    def initialize(logger = nil)
      @logger = logger || Logger.new($stdout)
    end

    def run(args)
      options = parse_args(args)
      validate_url!(options[:url])
      page_list = PageList.new(options[:url])
      crawler = Crawler.new(options[:url], page_list, @logger)
      crawler.crawl!
      output = SiteMapper.new(page_list).render
      handle_output(output, options[:output])
    end

    private

    def handle_output(output_data, output)
      if output
        File.open(output, 'w') { |file| file.write(output_data) }
      else
        puts output_data
      end
    end

    def parse_args(args)
      Hash.new.tap do |options|
        OptionParser.new do |opts|
          opts.on("-o", "--output-file FILE_NAME", "./sitemap.html") do |file_name|
            options[:output] = file_name
          end

          opts.on("-u", "--url URL_TO_CRAWL", "e.g. -u https://www.digitalocean.com/") do |url|
            options[:url] = url
          end
        end.parse!(args)
        if options[:url].blank?
          raise OptionParser::MissingArgument.new("Missing url! Usage: site_mapper -u URL")
        end
      end
    end

    def validate_url!(url)
      raise ArgumentError.new("Invalid URL given") unless url =~ URI::regexp
    end
  end

end
