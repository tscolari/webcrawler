module WebCrawler
  #
  # Crawler
  #
  # This class is responsible for given an url visit all the linked pages
  # within the same domain.
  #
  class Crawler

    def initialize(url, page_list = nil, logger = nil, link_tracker = LinkTracker.new)
      @uri = URI(url)
      @link_tracker = link_tracker
      @page_list = page_list || PageList.new(@uri)
      @logger = logger || Logger.new($stdout)
    end

    def crawl!
      craw_url(@uri)
    end

    private

    def craw_url(url)
      uri = normalize_url(url.to_s)
      return if url_was_visited?(uri.path)

      @logger.info("[CRAWLER] crawling: #{uri.path}")
      page = @page_list.fetch(uri)
      mark_as_visited(page)
      crawl_internal_links_from_page(page)
    end

    def crawl_internal_links_from_page(page)
      page.internal_links.each do |link|
        craw_url(link)
      end
    end

    def url_was_visited?(url)
      @link_tracker.visited?(url)
    end

    def mark_as_visited(page)
      @link_tracker.visit!(page.path)
    end

    def normalize_url(url)
      @uri + URI(url).tap do |uri|
        uri.path = "/" if uri.path.blank?
      end.path
    rescue URI::InvalidURIError
      @logger.error("[CRAWLER] Error crawling '#{url}'. Skipping url...")
    end

  end
end
