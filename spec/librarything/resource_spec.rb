require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LibraryThing::Resource do
  it "complains about trying to get a Resource instance" do
    lambda {
      LibraryThing::Resource.get(:id => '123')
    }.should raise_error(LibraryThing::Error, 'Cannot get a generic resource. Try LibraryThing::Work.get or LibraryThing::Author.get')
  end
end
