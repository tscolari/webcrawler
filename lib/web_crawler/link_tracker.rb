module WebCrawler
  #
  # LinkTracker
  #
  # A LinkTracker instance is responsible for keeping track of visited urls,
  # it's used so the same link is not visited twice.
  #
  class LinkTracker
    class RepeatedLinkError < StandardError; end

    def initialize(visited_links = Set.new)
      raise ArgumentError.new("visited linsk must be an Enumerable") unless visited_links.is_a?(Enumerable)
      @visited_links = visited_links
    end

    def visited?(path)
      @visited_links.include?(path)
    end

    def visit!(path_or_url)
      raise RepeatedLinkError.new("'#{path_or_url}' already was visited.") if visited?(path_or_url)
      @visited_links << path(path_or_url)
    end

    private

    def path(path_or_url)
      URI(path_or_url).path
    end

  end
end
