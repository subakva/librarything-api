require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe LibraryThing do
  it "should require the Work class" do
    defined?(LibraryThing::Work).should be_true
  end

  it "should require the Author class" do
    defined?(LibraryThing::Author).should be_true
  end
end
