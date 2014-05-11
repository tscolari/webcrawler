require 'spec_helper'

module WebCrawler
  describe SiteMapper do

    let(:sample_page) do
      """
      <html>
        <head>
          <link href='http://getbootstrap.com/dist/css/bootstrap.min.css' rel='stylesheet'>
          <title>Sample test page</title>
        </head>
        <body>
          Sample.com domain links:
            <a href='http://sample.com/ghpage1'>Test page 1</a>
          <img src='supercool.png'/>
        </body>
      </html>
      """
    end
    let(:page_list) { PageList.new("http://sample.com") }
    before do
      stub_request(:any, /.*sample.*/).to_return(body: sample_page, status: 200)
      page_list.fetch("/")
    end

    let(:site_mapper) { SiteMapper.new(page_list) }

    describe "#render" do
      subject { Nokogiri::HTML(site_mapper.render) }

      it "should use the path MD5 as anchor ID of items" do
        subject.css("div.title").each do |page_title|
          current_title_anchor = page_title.css("strong").first.attributes["id"].value
          current_title_url = page_title.css("span").first.content
          expect(current_title_anchor).to eq(Digest::MD5.hexdigest(current_title_url))
        end
      end

      it "should link to the correct MD5 for each internal link" do
        page_list.each do |path, page|
          page.internal_links.each do |link|
            path_md5 = Digest::MD5.hexdigest(link.path)
            expect(subject.css("a[href=\"##{path_md5}\"]").first.content).
              to eq(link.path)
          end
        end
      end
    end

  end
end
