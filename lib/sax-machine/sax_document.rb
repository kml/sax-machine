require "nokogiri"

module SAXMachine
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  def parse(xml_text)
    sax_handler = SAXHandler.new(self)
    parser = Nokogiri::XML::SAX::Parser.new(sax_handler)
    parser.parse(xml_text)
    self
  end
  
  def parse_element?(name)
    self.class.sax_config.parse_element?(name)
  end
  
  module ClassMethods

    def parse(xml_text)
      new.parse(xml_text)
    end
    
    def element(name, options = {})
      options[:as] ||= name
      sax_config.add_top_level_element(name, options)
      attr_accessor options[:as]
    end
    
    def sax_config
      @sax_config ||= SAXConfig.new
    end
  end
  
end