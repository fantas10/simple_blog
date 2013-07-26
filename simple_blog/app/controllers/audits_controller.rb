class AuditsController < ApplicationController
  
  http_basic_authenticate_with name: 'eddie', password: 'admin'
  
  def index
    @zruby = Zruby.new
    @messages = @zruby.subscribe
    
    Rails.logger.info "DEBUG >>>>> " + @messages
    
    @items = JSON.parse(@messages)
    
  end
end
