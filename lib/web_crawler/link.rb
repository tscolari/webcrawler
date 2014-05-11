module WebCrawler
  #
  # Link
  #
  # Internal representation of a url.
  # It adds some extra behavour while wrapping the URI class.
  #
  class Link
    class InvalidLink < StandardError; end

    def initialize(link_url, relative_to)
      @link_uri = URI(link_url)
      @relative_uri = URI(relative_to)
      normalize!
    rescue URI::InvalidURIError
      raise InvalidLink.new("Invalid link format!")
    end

    def internal?
      @link_uri.host == @relative_uri.host
    end

    def path
      @link_uri.path
    end

    def to_s
      @link_uri.to_s
    end

    private

    def normalize!
      if @link_uri.host.blank?
        @link_uri.host = @relative_uri.host
        @link_uri.scheme = @relative_uri.scheme
      end
    end

  end
end
