require File.expand_path(File.dirname(__FILE__) + "/shared_requires")

module LibraryThing
  class Work < LibraryThing::Base
    get_method 'librarything.ck.getwork'
  end
end
