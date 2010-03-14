require File.expand_path(File.dirname(__FILE__) + "/shared_requires")

module LibraryThing

  # 
  # Provides access to the LT Author API
  # Authors can be loaded by id, authorcode, or name
  # 
  #   # author = LibraryThing::Author.get(:id => 216)
  #   # author = LibraryThing::Author.get(:authorcode => 'clarkesusanna')
  #   author = LibraryThing::Author.get(:name => 'Clarke, Susanna')
  #   author['url]
  #   => "http://www.librarything.com/author/216"
  # 
  class Author < LibraryThing::Resource
    get_method 'librarything.ck.getauthor'
  end
end
