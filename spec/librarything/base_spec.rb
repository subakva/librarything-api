require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LibraryThing::Base do
  it "complains about trying to get a Base instance" do
    lambda {
      LibraryThing::Base.get(:id => '123')
    }.should raise_error(LibraryThing::Error, 'Try LibraryThing::Work.get or LibraryThing::Author.get')
  end
end
