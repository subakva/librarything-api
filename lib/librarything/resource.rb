module LibraryThing

  # Helper class to wrap a Nokogiri node. It includes a simplified method for accessing DOM content.
  class NodeWrapper

    attr_reader :node

    # Creates a new wrapped XML node
    def initialize(node)
      @node = node
    end

    # Returns the content of the node
    def content
      @node.content
    end

    # Extracts values from the node.
    # 
    # * If the name matches the name of an attribute, the value of that attribute will be returned
    # * If the name matches the name of a single child element, that element is returned.
    # * If the matching child element only contains text data, the text data is returned.
    # * If the matching child element is named xxxList, an array of the children of the element is returned
    # * If there is more that one matching child element, they are returned as an array.
    # 
    def [](name)
      # Check for attributes first. Why? It works for the LT xml (for now).
      if @node.attributes.has_key?(name)
        return @node.attributes[name].value
      end

      # Find child elements with that name
      children = @node.xpath("./lt:#{name}")
      if children.size == 1
        child = children.first
        if self.text_element?(child)
          return child.children.first.content
        elsif child.name =~ /^[\w]*List$/
          # LT-specific hack to simplify access to lists. Ill-advised?
          return wrap_children(child.children)
        else
          return NodeWrapper.new(child)
        end
      elsif children.size > 1
        return wrap_children(children)
      else
        return nil
      end
    end

    protected

    # Checks whether the node is an element with no attributes and a single text child
    def text_element?(node)
      node.element? && node.attributes.empty? && node.children.size == 1 && node.children.first.text?
    end

    # Creates and returns an array of wrapped nodes for each element in the NodeSet
    def wrap_children(children)
      children.map { |c| NodeWrapper.new(c) if c.element? }.compact
    end
  end

  # Base class for fetching and parsing data from the LT WebServices APIs
  class Resource
    include HTTParty
    base_uri 'http://www.librarything.com/services/rest/1.0'

    attr_reader :xml
    attr_reader :document
    attr_reader :item_node

    # Accepts xml from an LT API request and creates a wrapper object. If there is a problem with the format of the
    # xml, a LibraryThing::Error will be raised.
    def initialize(xml)
      @xml = xml
      @document = self.parse_response(@xml)
      @item_node = self.find_item_node(@document)
    end

    # See: LibraryThing::NodeWrapper#[](name)
    def [](name)
      @item_node[name]
    end

    protected

    def parse_response(xml)
      doc = Nokogiri::XML(xml)
      self.check_for_errors(doc)
      doc
    end

    def find_item_node(doc)
      doc.root.add_namespace('lt', 'http://www.librarything.com/')
      item = doc.xpath('/response/lt:ltml/lt:item').first
      raise LibraryThing::Error.new('Missing item element in response') if item.nil?
      NodeWrapper.new(item)
    end

    def check_for_errors(doc)
      response = doc.xpath('//response')
      raise LibraryThing::Error.new("LT response was missing the 'response' element.") if response.empty?

      statuses = doc.xpath('//response/@stat')
      status = statuses.first.value unless statuses.empty?
      if status && status != 'ok'
        errors = doc.xpath('//response/err')
        error = errors.first unless errors.empty?
        error_code = error.attributes['code'] if error
        error_message = error.content if error

        raise LibraryThing::Error.new("status = #{status}, error_code = #{error_code}, error_message = #{error_message}")
      end
    end

    class << self

      # Gets or sets the method name that will be passed to the LT web service.
      # Generally, this will be specified in a sub-class.
      def get_method(method_name = nil)
        if method_name
          @get_method = method_name
        elsif @get_method
          @get_method
        else
          raise LibraryThing::Error.new('Cannot get a generic resource. Try LibraryThing::Work.get or LibraryThing::Author.get')
        end
      end

      # Accepts a hash of query params, and generates a request to the LT API. Returns a wrapped response object. If
      # there is a problem with the request, a LibraryThing::Error will be raised.
      def get(query)
        raise LibraryThing::Error.new("Missing developer key. Please define LibraryThing::DEVELOPER_KEY") unless defined?(LibraryThing::DEVELOPER_KEY)

        all_params = {
          :apikey => LibraryThing::DEVELOPER_KEY,
          :method => self.get_method
        }.merge(query)

        response = super('', :query => all_params)
        self.new(response.body)
      end
    end
    
  end
end
