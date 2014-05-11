require 'spec_helper'

module WebCrawler
  describe LinkTracker do
    subject { LinkTracker.new }

    describe "#visited?" do
      let(:target_link) { "/link.html" }

      it "should return true for visited links" do
        visited_links = Set.new([target_link])
        expect(LinkTracker.new(visited_links).visited?(target_link)).to be_true
      end

      it "should return false for non visited links" do
        expect(subject.visited?(target_link)).to be_false
      end
    end

    describe "#visit!" do
      it "should add the link to the visited links list" do
        visited_links = Set.new
        link_tracker = LinkTracker.new(visited_links)

        expect {
          link_tracker.visit!("test.html")
        }.to change { visited_links.size }.by(1)
      end

      it "should raise errors if the link was already visited" do
        visited_links = Set.new(["test.html"])
        link_tracker = LinkTracker.new(visited_links)

        expect {
          link_tracker.visit!("test.html")
        }.to raise_error { LinkTracker::RepeatedLinkError }
      end
    end

  end
end
