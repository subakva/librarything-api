require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LibraryThing::Author do
  describe 'configuration' do
    it "knows the method name for getting an author" do
      LibraryThing::Author.get_method.should == 'librarything.ck.getauthor'
    end
  end

  describe '#get' do
    before(:each) do
      @fake_response = load_response_body(LibraryThing::Author.get_method, '216')
      @error_response = load_response_body(LibraryThing::Author.get_method, 'error')
      @crash_response = load_response_body(LibraryThing::Author.get_method, 'crash')
    end

    it "complains if the response is not xml" do
      expected_request_url = api_url(LibraryThing::Author.get_method, {:id => '216'})
      FakeWeb.register_uri(:get, expected_request_url, :body => 'Not xml' )

      lambda {
        LibraryThing::Author.get(:id => '216')
      }.should raise_error(LibraryThing::Error, 'LT response was missing the \'response\' element.')
    end

    it "complains if the response does not have the response element" do
      expected_request_url = api_url(LibraryThing::Author.get_method, {:id => '216'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @crash_response )

      lambda {
        LibraryThing::Author.get(:id => '216')
      }.should raise_error(LibraryThing::Error, 'LT response was missing the \'response\' element.')
    end

    it "complains if the response status is not 'ok'" do
      expected_request_url = api_url(LibraryThing::Author.get_method, {:id => '216'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @error_response )

      lambda {
        LibraryThing::Author.get(:id => '216')
      }.should raise_error(LibraryThing::Error, "status = fail, error_code = 106, error_message = Could not determine author from supplied arguments")
    end

    def check_author_response(author)
      author.should_not be_nil
      author['id'].should == '216'
      author['url'].should == 'http://www.librarything.com/author/216'

      author_element = author['author']
      author_element.should_not be_nil
      author_element['id'].should == '216'
      author_element['authorcode'].should == 'clarkesusanna'
      author_element['name'].should == 'Susanna Clarke'
      
      field_list = author['commonknowledge']['fieldList']
      field_list.size.should == 8
    end

    it "retrieves an author by id" do
      expected_request_url = api_url(LibraryThing::Author.get_method, {:id => '216'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @fake_response )

      author = LibraryThing::Author.get(:id => 216)
      check_author_response(author)
    end

    it "retrieves an author by authorcode" do
      expected_request_url = api_url(LibraryThing::Author.get_method, {:authorcode => 'clarkesusanna'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @fake_response )

      author = LibraryThing::Author.get(:authorcode => 'clarkesusanna')
      check_author_response(author)
    end

    it "retrieves an author by name" do
      expected_request_url = api_url(LibraryThing::Author.get_method, {:name => 'Clarke,+Susanna'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @fake_response )

      author = LibraryThing::Author.get(:name => 'Clarke,+Susanna')
      check_author_response(author)
    end
  end
end
