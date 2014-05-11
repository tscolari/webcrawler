require 'spec_helper'

module WebCrawler
  describe Crawler do
    let(:link_tracker) { LinkTracker.new }
    let(:page_list) { PageList.new("http://sample.com") }

    let(:sample_page) do
      """
      <html>
        <head>
          <title>Sample test page</title>
        </head>
        <body>
          Sample.com domain links:
            <a href='http://sample.com/ghpage1'>Test page 1</a>
            <a href='http://sample.com/ghpage2'>Test page 2</a>
            <a href='https://sample.com/ghpage3'>Test page 3 (https)</a>
          Test.com domain links:
            <a href='http://test.com/tspage1'>Test page 1</a>
            <a href='http://test.com/tspage2'>Test page 2</a>
            <a href='https://test.com/tspage3'>Test page 3 (https)</a>
        </body>
      </html>
      """
    end

    describe "#crawl!" do
      before do
        stub_request(:any, /.*sample.*/).to_return(body: sample_page, status: 200)
      end

      subject { Crawler.new("http://sample.com", page_list, Logger.new("/dev/null"), link_tracker) }

      it "should visit the root path" do
        expect {
          subject.crawl!
        }.to change { link_tracker.visited?("/") }.to be_true
      end

      ["/ghpage1", "/ghpage2", "/ghpage3"].each do |path|
        it "should visit the internal '#{path}' link" do
          expect {
            subject.crawl!
          }.to change { link_tracker.visited?(path) }.from(false).to(true)
        end
      end

      ["tspage1", "tspage2", "tspage3"].each do |path|
        it "should not have visited the external links" do
          expect {
            subject.crawl!
          }.to_not change { link_tracker.visited?(path) }.from(false).to(true)
        end
      end

      it "should add root path in the page list" do
        expect {
          subject.crawl!
        }.to change { page_list.get("/") }.from(nil).to(Page)
      end

      ["/ghpage1", "/ghpage2", "/ghpage3"].each do |path|
        it "should add the '#{path}' link to the page list" do
          expect {
            subject.crawl!
          }.to change { page_list.get(path) }.from(nil).to(Page)
        end
      end

    end
  end
end
