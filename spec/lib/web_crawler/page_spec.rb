require 'spec_helper'

module WebCrawler
  describe Page do
    let(:sample_page) do
      """
      <html>
        <head>
          <title>Sample test page</title>
          <link rel='icon' type='image/x-icon' href='https://domain.global.ssl.fastly.net/favicon.ico' />
          <link href='https://domain.global.ssl.fastly.net/assets/domain.css' media='all' rel='stylesheet' type='text/css' />
          <script src='https://domain.global.ssl.fastly.net/assets/domain.js' type='text/javascript'></script>
          <script>alert('this should not be added')</script>
          <link rel='stylesheet' type='text/css'>
            .do-not-add-me {
              color: green;
            }
          </link>
        </head>
        <body>
          <img src='https://somedomain.com/image.png' />
          <img src='https://example.com/image.png' />
          <img src='https://example.com/image.png' class='duplicated'/>
          example.com domain links:
            <a href='http://example.com/ghpage1'>Test page 1</a>
            <a href='http://example.com/ghpage2'>Test page 2</a>
            <a href='https://example.com/ghpage3'>Test page 3 (https)</a>
          example.com with subdomain links:
            <a href='http://test.example.com/sub-ghpage1'>Test page 1</a>
            <a href='http://test.example.com/sub-ghpage2'>Test page 2</a>
            <a href='https://test.example.com/sub-ghpage3'>Test page 3 (https)</a>
          Test.com domain links:
            <a href='http://test.com/tspage1'>Test page 1</a>
            <a href='http://test.com/tspage2'>Test page 2</a>
            <a href='https://test.com/tspage3'>Test page 3 (https)</a>
        </body>
      </html>
      """
    end

    before do
      [/.*example.com.*/, /.*test.com.*/].each do |domain|
        stub_request(:any, domain).
          to_return(
            body: sample_page,
            status: 200
          )
      end
    end

    let(:example_page) { Page.new("http://example.com") }
    let(:test_page) { Page.new("http://test.com") }
    let(:domain_subdomain_page) { Page.new("http://test.example.com") }

    describe "#path" do
      it "should be relative path of the page" do
        expect(
          Page.new("http://testing.com/path/to/page").path
        ).to eq("/path/to/page")
      end
    end

    describe "#url" do
      it "should return the full url" do
        expect(
          Page.new("http://testing.com/path/to/page").url
        ).to eq("http://testing.com/path/to/page")
      end
    end

    describe "#internal_links" do
      context "when the domain is example.com" do
        it "should contain all example.com links" do
          expect(
            example_page.internal_links.map(&:to_s)
          ).to include(
            "http://example.com/ghpage1",
            "http://example.com/ghpage2",
            "https://example.com/ghpage3"
          )
        end

        it "should not contain subdomain nor different domain links" do
          expect(
            example_page.internal_links.map(&:to_s)
          ).to_not include(
            "http://test.example.com/sub-ghpage1",
            "http://test.example.com/sub-ghpage2",
            "https://test.example.com/sub-ghpage3",
            "http://test.com/tspage1",
            "http://test.com/tspage2",
            "https://test.com/tspage3"
          )
        end
      end
    end

    describe "#title" do
      it "should return the correct page title" do
        expect(test_page.title).to eq("Sample test page")
      end
    end

    describe "#images" do
      it "should include all page images" do
        expect(
          test_page.images
        ).to include(
          "https://somedomain.com/image.png",
          "https://example.com/image.png"
        )
      end

      it "should not contain duplicated items" do
        expect(
          test_page.images.count
        ).to be(2)
      end
    end

    describe "#javascript_includes" do
      it "should include all javascript tags with src" do
        expect(
          test_page.javascript_includes
        ).to include("https://domain.global.ssl.fastly.net/assets/domain.js")
      end

      it "should not include script tags without src" do
        expect(
          test_page.javascript_includes.count
        ).to be(1)
      end
    end

    describe "#link_includes" do
      it "should include all javascript tags without src" do
        expect(
          test_page.link_includes
        ).to include(
          "https://domain.global.ssl.fastly.net/favicon.ico",
          "https://domain.global.ssl.fastly.net/assets/domain.css"
        )
      end

      it "should not include link tags with href" do
        expect(
          test_page.link_includes.count
        ).to be(2)
      end
    end

    describe "#assets" do
      it "should include all javascript, stylesheets/links includes and images" do
        expect(
          test_page.assets
        ).to include(
          "https://domain.global.ssl.fastly.net/favicon.ico",
          "https://domain.global.ssl.fastly.net/assets/domain.css",
          "https://domain.global.ssl.fastly.net/assets/domain.js",
          "https://somedomain.com/image.png",
          "https://example.com/image.png"
        )
      end
    end

  end
end
