require File.expand_path(File.dirname(__FILE__) + "/shared_requires")

module LibraryThing

  class NodeWrapper

    attr_reader :node

    def initialize(node)
      @node = node
    end

    def content
      @node.content
    end

    def [](name)
      # Check for attributes first. Why? It works for the LT xml (for now).
      if @node.attributes.has_key?(name)
        return @node.attributes[name].value
      end

      # Find child elements with that name
      children = @node.xpath("lt:#{name}")
      if children.size == 1
        child = children.first

        # LT-specific hack to simplify access to lists. Ill-advised?
        if child.name =~ /^[\w]*List$/
          return child.children.map { |c| NodeWrapper.new(c) if c.element? }.compact
        else
          return NodeWrapper.new(child)
        end
      elsif children.size > 1
        return children.map { |c| NodeWrapper.new(c) }
      else
        return nil
      end
    end
  end

  class Work
    include HTTParty

    base_uri 'http://www.librarything.com/services/rest/1.0'
    default_params :method => 'librarything.ck.getwork'

    attr_reader :xml
    attr_reader :document
    attr_reader :item_node

    def initialize(xml)
      @xml = xml
      @document = self.parse_response(@xml)
      @item_node = self.find_item_node(@document)
    end

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
      def get_method
        'librarything.ck.getwork'
      end

      def get(query)
        raise LibraryThing::Error.new("Missing developer key. Please define LibraryThing::DEVELOPER_KEY") unless defined?(LibraryThing::DEVELOPER_KEY)
        self.default_params :apikey => LibraryThing::DEVELOPER_KEY

        response = super('', :query => query)
        Work.new(response.body)
      end
    end

  end

end
