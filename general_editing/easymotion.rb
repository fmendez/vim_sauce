# Navigate the code using easy motion.
#
require "base64"
require_relative "spec_helper"

describe Configuration do
  describe "choices" do
    it "removes leading and trailing whitespace" do
      config = Configuration.from_inputs([" a choice "],
                                         Configuration.default_options)
      expect(config.choices).to eq ["a choice"]
    end

    it "silences invalid UTF characters" do
      path = File.expand_path(File.join(File.dirname(__FILE__),
                                        "invalid_utf8.txt"))
      invalid_string = File.read(path)

      # Make sure that the string is actually invalid.
      expect do
        invalid_string.strip
      end.to raise_error(ArgumentError, /invalid byte sequence in UTF-8/)

      # We should silently fix the error
      config = Configuration.from_inputs([invalid_string],
                                         Configuration.default_options)
      expect(config.choices).to eq [""]
      expect(config.choices).not_to eq [invalid_string]
    end
  end

  describe "command line options" do
    describe "search queries" do
      it "can be specified" do
        config = Configuration.from_inputs(
          [], Configuration.parse_options(["-s", "some search"]))
        expect(config.initial_search).to eq "some search"
      end

      it "defaults to the empty string" do
        config = Configuration.from_inputs([], Configuration.default_options)
        expect(config.initial_search).to eq("")
      end
    end
  end
end
