require 'time'

# class to handle blog calls to ZMQ 
class GInfo
    attr_accessor :author, :client
    
    def initialize(author, client)
      # in milisecs
     @timestamp = (Time.now.to_f * 1000.0).to_i
     @author = author
     @client = client
    end
    
    def author
      @author
    end
    def author=(author)
        @author = author
    end
    
    def client
      @client
    end  
    def client=(client)
        @client = client
    end
    
    def text
      @text
    end
    def text=(text)
      @text = text
    end
  
    def timestamp
      @timestamp
    end
    def timestamp=(timestamp)
      @timestamp = timestamp
    end  
      
    def title
      @title
    end
    def title=(title)
      @title = title
    end  
  
    # :create, :update
    def operation
      @operation
    end
    def operation=(operation)
      @operation = operation
    end
    
    # :article, :comment
    def type
      @type
    end
    def type=(type)
      @type = type
    end
    
end