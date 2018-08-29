require "spec_helper"

require "active_support/core_ext/string"

describe String do

  describe "#underscore" do

    it "should return the lower case version of single words" do
      expect("Post".underscore).to eql "post"
    end

    it "should return lower_snake_case for UpperCamelCase words" do
      expect("MyCoolString".underscore).to eql "my_cool_string"
    end

    it "should return lower_snake_case for UpperCamelCase words with numbers" do
      expect("M2MyCoolString".underscore).to eql "m2_my_cool_string"
      expect("MyNumberIs2andString".underscore).to eql "my_number_is2and_string"
    end

  end

  describe "#pluralize" do
    it "should add an 's' on the end of the word" do
      expect("post".pluralize).to eql "posts"
      expect("foot".pluralize).to eql "foots"
      expect("spider".pluralize).to eql "spiders"
    end
  end

  describe "#singularize" do
    it "should remove the 's' from the end of a word" do
      expect("posts".singularize).to eql "post"
      expect("foots".singularize).to eql "foot"
      expect("feet".singularize).to eql "feet"
    end
  end

end
