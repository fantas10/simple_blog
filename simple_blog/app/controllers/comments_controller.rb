class CommentsController < ApplicationController
  
  #http_basic_authenticate_with name: "eddie", password: "vedder", only: :destroy
  
  # POST /comments
  # POST /comments.json
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment])

    @zruby = Zruby.new
    @zruby.auditComment(@comment, :create)
      
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.article, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { redirect_to @comment.article }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    Rais.debug.info ">>>>>>>>>>>> DESTROY COMMENTS!!"
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @comment.article }
      format.json { head :no_content }
    end
  end
end
