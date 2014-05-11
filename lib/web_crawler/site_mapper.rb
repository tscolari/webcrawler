module WebCrawler
  #
  # SiteMapper
  #
  # The SiteMapper object is responsible for given a PageList object, render
  # it to the html form, as a site map.
  #
  class SiteMapper

    def initialize(page_list)
      @page_list = page_list
    end

    def render
      ERB.new(template.read).result(binding).to_s
    end

    private

    def template
      @template ||=
        File.open(File.expand_path('../templates/site_map.html.erb', __FILE__))
    end

  end
end
