require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LibraryThing::Work do
  describe 'configuration' do
    it "knows the method name for getting a work" do
      LibraryThing::Work.get_method.should == 'librarything.ck.getwork'
    end
  end

  describe '#get' do
    before(:each) do
      @fake_response = load_response_body(LibraryThing::Work.get_method, '1060')
      @error_response = load_response_body(LibraryThing::Work.get_method, 'error')
      @crash_response = load_response_body(LibraryThing::Work.get_method, 'crash')
    end

    it "complains if the response is not xml" do
      expected_request_url = api_url(LibraryThing::Work.get_method, {:id => '1060'})
      FakeWeb.register_uri(:get, expected_request_url, :body => 'Not xml' )

      lambda {
        LibraryThing::Work.get(:id => '1060')
      }.should raise_error(LibraryThing::Error, 'LT response was missing the \'response\' element.')
    end

    it "complains if the response does not have the response element" do
      expected_request_url = api_url(LibraryThing::Work.get_method, {:id => '1060'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @crash_response )

      lambda {
        LibraryThing::Work.get(:id => '1060')
      }.should raise_error(LibraryThing::Error, 'LT response was missing the \'response\' element.')
    end

    it "complains if the response status is not 'ok'" do
      expected_request_url = api_url(LibraryThing::Work.get_method, {:id => '1060'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @error_response )

      lambda {
        LibraryThing::Work.get(:id => '1060')
      }.should raise_error(LibraryThing::Error, "status = fail, error_code = 105, error_message = Could not find work ID matching supplied arguments")
    end

    def check_work_response(work)
      work.should_not be_nil
      work['id'].should == '1060'
      work['url'].content.should == 'http://www.librarything.com/work/1060'

      author = work['author']
      author.should_not be_nil
      author['id'].should == '216'
      author['authorcode'].should == 'clarkesusanna'
      author.content.should == 'Susanna Clarke'
      
      field_list = work['commonknowledge']['fieldList']
      field_list.size.should == 15

      epigraph = field_list.first
      epigraph['type'].should == '28'
      epigraph['name'].should == 'epigraph'
      epigraph['displayName'].should == 'Epigraph'
      epigraph['versionList'].size.should == 1
      
      work['garbage'].should be_nil
    end

    it "retrieves a work by id" do
      expected_request_url = api_url(LibraryThing::Work.get_method, {:id => '1060'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @fake_response )

      work = LibraryThing::Work.get(:id => 1060)
      check_work_response(work)
    end

    it "retrieves a work object by isbn" do
      expected_request_url = api_url(LibraryThing::Work.get_method, {:isbn => '0765356155'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @fake_response )

      work = LibraryThing::Work.get(:isbn => '0765356155')
      check_work_response(work)
    end

    # Note: This appears to be broken on LT.
    # 
    # http://www.librarything.com/services/rest/1.0/?method=librarything.ck.getwork&lccn=PR6103.L375J65&apikey=XXXXXXX
    # 
    # <font color=ff0000>
    # Warning: Missing argument 2 for workforLCCNorOCLC(), called in /var/www/html/services/rest/1.0/class_WS_CommonKnowledge.php on line 209 and defined in /var/www/html/inc_thingISBN.php on line 5
    # </font><font color=ff0000>
    # Warning: Invalid argument supplied for foreach() in /var/www/html/inc_thingISBN.php on line 13
    # </font><?xml version="1.0" encoding="UTF-8"?>
    # <response stat="fail"><err code="105">Could not find work ID matching supplied arguments</err></response>
    # 
    it "retrieves a work object by lccn" do
      expected_request_url = api_url(LibraryThing::Work.get_method, {:lccn => 'PR6103.L375J65'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @fake_response )

      work = LibraryThing::Work.get(:lccn => 'PR6103.L375J65')
      check_work_response(work)
    end

    # Note: This appears to be broken on LT.
    # 
    # http://www.librarything.com/services/rest/1.0/?method=librarything.ck.getwork&oclc=185392674&apikey=XXXXXXX
    # 
    # <font color=ff0000>
    # Warning: Invalid argument supplied for foreach() in /var/www/html/inc_thingISBN.php on line 12
    # </font><?xml version="1.0" encoding="UTF-8"?>
    # <response stat="fail"><err code="105">Could not find work ID matching supplied arguments</err></response>
    # 
    it "retrieves a work object by oclc id" do
      expected_request_url = api_url(LibraryThing::Work.get_method, {:oclc => '185392674'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @fake_response )

      work = LibraryThing::Work.get(:oclc => '185392674')
      check_work_response(work)
    end

    it "retrieves a work object by name" do
      expected_request_url = api_url(LibraryThing::Work.get_method, {:name => 'Jonathan+Strange'})
      FakeWeb.register_uri(:get, expected_request_url, :body => @fake_response )

      work = LibraryThing::Work.get(:name => 'Jonathan+Strange')
      check_work_response(work)
    end
  end
end
