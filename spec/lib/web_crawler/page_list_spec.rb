require 'spec_helper'

module WebCrawler
  describe PageList do
    let(:pages_hash) { Hash.new }
    let(:base_url) { "http://test.com" }
    subject { PageList.new(base_url, pages_hash) }

    describe "#add" do
      it "should add the item to the pages hash" do
        page = Page.new("http://page.com/index")
        expect {
          subject.add(page)
        }.to change { pages_hash["/index"] }.from(nil).to(page)
      end

      it "should override existing pages" do
        pages_hash = { "/index" => "old" }
        page = Page.new("http://page.com/index")
        subject = PageList.new(base_url, pages_hash)

        expect {
          subject.add(page)
        }.to change { pages_hash["/index"] }.from("old").to(page)
      end

      it "should raise if argument is not a Page" do
        expect {
          subject.add("Testing")
        }.to raise_error(ArgumentError)
      end
    end

    describe "#fetch" do
      context "when page is already in the list" do
        let(:page) { Page.new(File.join(base_url, "/index.html")) }
        let(:pages_hash) { {"/index.html" => page} }

        it "should return the matching page" do
          expect(
            subject.fetch("/index.html")
          ).to eq(page)
        end

        it "should match if its a full url" do
          expect(
            subject.fetch(File.join(base_url, "index.html"))
          ).to eq(page)
        end
      end

      context "when page is not in the list already" do
        it "should create a new page based on the url given" do
          expect{
            subject.fetch(File.join(base_url, "test.html"))
          }.to change { pages_hash.size }.from(0).to(1)
        end

        it "should use the base_url even if a different full url is given" do
          expect(
            subject.fetch("http://sample.com/test.html").url
          ).to eq(File.join(base_url, "test.html"))
        end
      end
    end

    describe "#each" do
      it "should yield control to block with path and page" do
        pages_hash = { "/index.html" => "my-page" }
        subject = PageList.new(base_url, pages_hash)

        expect { |block|
          subject.each(&block)
        }.to yield_with_args("/index.html", "my-page")
      end

      it "should yield as many times as pages in the hash" do
        pages_hash = { "/1" => "1", "/2" => "2", "/3" => "3" }
        subject = PageList.new(base_url, pages_hash)

        expect { |block|
          subject.each(&block)
        }.to yield_control.exactly(3).times
      end
    end

  end
end
