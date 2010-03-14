require 'fakeweb'
require 'rack'

def spec_support_dir
  File.expand_path(File.join(File.dirname(__FILE__), '..'))
end

def load_response_body(method, id)
  parts = [spec_support_dir, 'responses', method, "#{id}.xml"]
  File.new(File.join(parts)).read
end

def api_url(method, params, include_key = true)
  all_params = {:apikey => 'lt_test_key', :method => method}.merge(params) if include_key
  all_params ||= params
  query_string = Rack::Utils.build_query(all_params)
  "http://www.librarything.com/services/rest/1.0?" + query_string
end

FakeWeb.allow_net_connect = false
