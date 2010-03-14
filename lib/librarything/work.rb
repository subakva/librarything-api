require File.expand_path(File.dirname(__FILE__) + "/shared_requires")

module LibraryThing

  # 
  # Provides access to the LT Work API
  # Works can be loaded by id, isbn, lccn, oclc or name
  # 
  #   # work = LibraryThing::Work.get(:id => 1060)
  #   # work = LibraryThing::Work.get(:isbn => '0765356155')
  #   # work = LibraryThing::Work.get(:lccn => 'PR6103.L375J65')
  #   # work = LibraryThing::Work.get(:oclc => '185392674')
  #   work = LibraryThing::Work.get(:name => 'Jonathon Strange')
  #   work['url]
  #   => "http://www.librarything.com/work/1060"
  # 
  # Note: lccn amd oclc access wasn't working while I was testing. (13-Mar-2010)
  # 
  class Work < LibraryThing::Resource
    get_method 'librarything.ck.getwork'
  end
end
