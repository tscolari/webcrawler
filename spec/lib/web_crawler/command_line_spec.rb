require 'spec_helper'
require_relative '../../../lib/web_crawler/command_line'

module WebCrawler
  describe CommandLine do

    subject { WebCrawler::CommandLine.new(Logger.new('/dev/null')) }

    let(:output_file) { "./spec/tmp/test.html" }
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
            <a href='http://sample.com/ghpage2'>Test page 2</a>
            <a href='https://sample.com/ghpage3'>Test page 3 (https)</a>
          <img src='supercool.png'/>
        </body>
      </html>
      """
    end

    describe "#run" do
      context "no url given" do
        it "should raise MissingArgument error" do
          expect {
            subject.run([])
          }.to raise_error(OptionParser::MissingArgument)
        end
      end

      context "invalid url given" do
        it "should raise ArgumentError" do
          expect {
            subject.run(["-u", "1234"])
          }.to raise_error(ArgumentError)
        end
      end

      context "output" do
        before do
          stub_request(:any, /.*sample.*/).to_return(body: sample_page, status: 200)
        end

        context "no argument given" do
          it "should output to the screen" do
            STDOUT.should_receive(:puts).once
            subject.run(["-u", "http://sample.com"])
          end
        end

        context "argument given" do
          before { File.delete(output_file) if File.exists?(output_file) }

          it "should not output to the screen" do
            STDOUT.should_not_receive(:puts)
            subject.run(["-u", "http://sample.com", "-o", output_file])
          end

          it "should output to the given file" do
            expect {
              subject.run(["-u", "http://sample.com", "-o", output_file])
            }.to change { File.exists?(output_file) }.from(false).to(true)
          end
        end

        context "content" do
          before { subject.run(["-u", "http://sample.com", "-o", output_file]) }

          it "should have all the links" do
            expect(File.open(output_file).read).
              to include("Sample test page", "/ghpage1", "/ghpage2", "/ghpage3")
          end

          it "should have all the assets" do
            expect(File.open(output_file).read).
              to include("http://getbootstrap.com/dist/css/bootstrap.min.css")
          end
        end

      end
    end
  end
end
