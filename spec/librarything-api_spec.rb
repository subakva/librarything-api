require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "LibrarythingApi" do
  it "should require the librarything library" do
    defined?(LibraryThing).should be_true
  end
end
