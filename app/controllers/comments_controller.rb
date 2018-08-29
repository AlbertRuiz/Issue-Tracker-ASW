class CommentsController < ApplicationController
 
def destroy
   @user_aux = authenticate
    if(@user_aux.nil?)
      respond_to do |format|
      format.json {render json: { 
       meta: {code: 401, error_message: "Unauthorized"}
      }}
    end
  else
    @comment = Comment.find_by_id(params[:id])
    if(Comment.find_by_id(params[:id]))
      @comment.destroy
      respond_to do |format|
      @issue = Issue.find_by_id(@comment.issue_id)
      self_aux = String.new
      self_aux = "/comments/" + params[:id]
      self_aux1 = String.new
      self_aux1 = "/issues/" + @comment.issue_id.to_s
      self_aux2 = String.new
      self_aux2 = "/users/" + @issue.user_id.to_s
      self_array = {'href' => self_aux}
      issue_array = {'href' => self_aux1}
      creator_array = {'href' => self_aux2}
      array_links = Array.new
      array_links = {'self' => self_array,
                    'user' => creator_array,
                    'issue' => issue_array}
      format.json {render json: {meta: {code: 200, message: "Comment deleted"},
      _links: array_links}}
      end
    else
      respond_to do |format|
      format.json {render json: {meta: {code: 404, error_message: "Comment not found"}}}
      end
    end
  end
end

  def update
  @user_aux = authenticate
  if(@user_aux.nil?)
      respond_to do |format|
      format.json {render json: { 
       meta: {code: 401, error_message: "Unauthorized"}
      }}
    end
  else 
    @comment = Comment.find_by_id(params[:id])
    request_parameters = JSON.parse(request.body.read.to_s)
    description = request_parameters["text"]
    if (@comment)
      @comment.update_attribute(:description,description)
      @issue = Issue.find_by_id(@comment.issue_id)
      self_aux = String.new
      self_aux = "/comments/" + params[:id]
      self_aux1 = String.new
      self_aux1 = "/issues/" + @comment.issue_id.to_s
      self_aux2 = String.new
      self_aux2 = "/users/" + @issue.user_id.to_s
      self_array = {'href' => self_aux}
      issue_array = {'href' => self_aux1}
      creator_array = {'href' => self_aux2}
      array_links = Array.new
      array_links = {'self' => self_array,
                    'user' => creator_array,
                    'issue' => issue_array}
      render json: {
          meta: {code: 200, message: "Comment Modified"},
          data: {comment: {id: @comment.id, text: @comment.description, created_at:@comment.created_at},
                        user_creator: {User: User.select("id,name,email").find_by_id(@comment.user_id)}},
          _links: array_links}
    else
    render json: { 
       meta: {code: 404, error_message: "Comment not found"}
      }
    end
  end
end

  private

  #def comment_params
  #  params.require(:comment).permit(:description)
  #end

end
