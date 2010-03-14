require File.expand_path(File.dirname(__FILE__) + "/shared_requires")

module LibraryThing
  class Author < LibraryThing::Base
    get_method 'librarything.ck.getauthor'
  end
end
