require 'spec_helper'

describe TestController do
  context "when the user submits an empty form" do

    it "should create no questions nor responses" do
      pending "writing"
    end
  end

  context "when the user submits a question with choices but no text" do
    it "should not create a question for the choices" do
      pending "writing"
    end
  end

  context "when the user submits a question with text but no choices" do
    it "should not create a question" do
      pending "writing"
    end
  end

  context "when the professor enters question text with ASCII characters" do
    it "should create a question with the proper text" do
      pending "writing"
    end
  end

  context "when the professor enters question text with Unicode characters" do
    it "should create a question with the proper text" do
      pending "writing"
    end
  end

  context "when the professor only enters information for the last question" do
    it "should create that question properly" do
      pending "writing"
    end
  end

  context "when the professor only enters question information for 1st question" do
    it "should create that question properly" do
      pending "writing"
    end
  end
end
