class AuditsController < ApplicationController
  def index
    @zruby = Zruby.new
    @messages = @zruby.subscribe
    
    Rails.logger.info "DEBUG >>>>> " + @messages
    
    @items = JSON.parse(@messages)
    
  end
end
