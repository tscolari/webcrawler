module WebCrawler
  #
  # Page
  #
  # A page instance is the internal representation of a page.
  # It will lazily fetch and parse the page when needed.
  #
  #
  class Page

    def initialize(url)
      @uri = URI(url)
    end

    def path
      @uri.path.to_s
    end

    def url
      @uri.to_s
    end

    def title
      @title ||= document.title
    end

    def internal_links
      @internal_links ||= parse_internal_links
    end

    def assets
      link_includes + javascript_includes + images
    end

    def images
      @images ||= set_of_elements_attributes(selector: 'img', attribute: 'src')
    end

    def javascript_includes
      @javascripts ||= set_of_elements_attributes(selector: 'script', attribute: 'src')
    end

    def link_includes
      @link_includes ||= set_of_elements_attributes(selector: 'link', attribute: 'href')
    end

    private

    def document
      @document ||= Nokogiri::HTML(Net::HTTP.get(@uri))
    end

    def links
      @links ||=
        set_of_elements_attributes(selector: 'a', attribute: 'href').map do |url|
          begin
            Link.new(url, @uri)
          rescue Link::InvalidLink
            nil
          end
        end.reject { |link| link.blank? || link.path.blank? }
    end

    def set_of_elements_attributes(selector:, attribute:)
      Set.new.tap do |elements_set|
        document.css(selector).each do |element|
          if element.attributes[attribute] && element.attributes[attribute].value
            elements_set.add(element.attributes[attribute].value)
          end
        end
      end
    end

    def parse_internal_links
      links.select do |link|
        link.internal?
      end.uniq { |link| link.to_s }
    end

  end
end
