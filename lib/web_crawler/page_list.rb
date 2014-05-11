module WebCrawler
  #
  # PageList
  #
  # Page list is a structure to keep track of the pages that were already visited,
  # it also fetches the page on the fly in case it was not visited yet.
  #
  class PageList
    def initialize(base_url, pages = Hash.new)
      raise ArgumentError.new("pages must be a Hash") unless pages.is_a?(Hash)
      @base_uri = URI(base_url)
      @base_uri.path = ""
      @pages = pages
    end

    def add(page)
      raise ArgumentError.new('argument must be a Page') unless page.is_a?(Page)
      @pages[page.path] = page
    end

    def get(path_or_url)
      uri = normalized_uri(path_or_url)
      @pages[uri.path]
    end

    def fetch(path_or_url)
      uri = normalized_uri(path_or_url)
      @pages[uri.path] ||= Page.new(uri)
    end
    alias :find :fetch

    def each
      @pages.each do |path, page|
        yield(path, page)
      end
    end

    private

    def normalized_uri(path_or_url)
      @base_uri + URI(path_or_url).path
    end
  end
end
