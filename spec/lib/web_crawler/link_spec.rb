require 'spec_helper'

module WebCrawler
  describe Link do

    describe "#internal?" do
      it "should be true for an relative url" do
        expect(
          Link.new("/contact", "http://www.sample.com").internal?
        ).to be_true
      end

      it "should be true if the url host is the same of the relative_to" do
        expect(
          Link.new("http://sample.com/contact", "http://sample.com").internal?
        ).to be_true
      end

      it "should be false if the url host is not the same from the relative_to" do
        expect(
          Link.new("http://otherpage.com/contact", "http://sample.com").internal?
        ).to be_false
      end
    end

    describe "#path" do
      it "should be the path of the given url" do
        expect(
          Link.new("http://sample.com/contact", "http://sample.com").path
        ).to eq("/contact")
      end
    end

    describe "#to_s" do
      it "should be the full url as string" do
        expect(
          Link.new("http://sample.com/contact", "http://sample.com").to_s
        ).to eq("http://sample.com/contact")
      end

      context "relative paths" do
        it "should append the path to the relative_to url" do
          expect(
            Link.new("/contact", "http://sample.com").to_s
          ).to eq("http://sample.com/contact")
        end
      end
    end

    context "Invalid urls given" do
      context "invalid link_url" do
        it "should throw an InvalidLink error" do
          expect {
            Link.new(1234, "http://sample.com").to_s
          }.to raise_error { Link::InvalidLink }
        end
      end

      context "invalid relative_to" do
        it "should throw an InvalidLink error" do
          expect {
            Link.new("http://sample.com", 1234).to_s
          }.to raise_error { Link::InvalidLink }
        end
      end
    end

  end
end
