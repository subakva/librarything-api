require File.expand_path(File.dirname(__FILE__) + "/shared_requires")

module LibraryThing
  class Author < LibraryThing::Resource
    get_method 'librarything.ck.getauthor'
  end
end
