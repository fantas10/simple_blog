require 'socket'
require 'rubygems'
require 'json'
require 'ginfo.rb'
require 'ffi-rzmq'

class Zruby < ApplicationController
  
  def initialize()
  end  
  
  def auditArticle(article, operation)
    Rails.logger.info "DEBUG article : " + article.inspect
    #
    ip = IPSocket.getaddress(Socket.gethostname)
    info = GInfo.new "eddie", ip
    info.text = article.body
    info.title = article.title
    info.type = :article
    info.operation = operation
    send info      
  end

  
  def auditComment(comment, operation)
    Rails.logger.info "DEBUG comment : " + comment.inspect
    #
    ip = IPSocket.getaddress(Socket.gethostname)
    info = GInfo.new "eddie", ip
    info.text = comment.body
    info.title = comment.article_id
    info.type = :comment
    info.operation = operation
    send info  
  end
    
  def send(ginfo)
    s = JSON.generate(ginfo)
    Rails.logger.info "DEBUG >>>>> " + s
    
    ctx = ZMQ::Context.create(1)
    Rails.logger.error "ZMQ: Failed to create a Context" unless ctx
    Rails.logger.info "ZMQ: initiating thread"
    
    #Here we're creating our first socket. Sockets should not be shared among threads.
    req = ctx.socket(ZMQ::REQ)
    req.connect("tcp://localhost:5555")
    
    #error_check(req.setsockopt(ZMQ::LINGER, 0))
    #rc = req.bind('tcp://127.0.0.1:2200')
    #error_check(rc)
    
    Rails.logger.info "ruby client connected..."
    
    1.times do |i|
      
      #This will block till a PULL socket connects`
      req.send_string(s)
      reply = ''
      req.recv_string(reply)
      Rails.logger.info "ZMQ: Reply: " + reply
      
      #Lets wait a second between messages
      sleep 1
    end
    
    req.close
  end
  
  
  def subscribe
    #start
    ctx = ZMQ::Context.create(1)
    #STDERR.puts "Failed to create a Context" unless ctx
    Rails.logger.info "ZMQ:Sub initiating thread"
    
    # Connect our subscriber socket
    sub = ctx.socket(ZMQ::SUB)
    sub.setsockopt(ZMQ::IDENTITY, "simpleBlog++")
    sub.setsockopt(ZMQ::SUBSCRIBE, "")
    sub.connect("tcp://localhost:5570")
    
    # Synchronize with publisher
    push = ctx.socket(ZMQ::PUSH)
    push.connect("tcp://localhost:5569")
    
    # Get updates
    push.send_string('sb++')
    topic = ''
    rc = sub.recv_string(topic)
    sub.close
    push.close
    #sleep 1
    return topic    
  end
end