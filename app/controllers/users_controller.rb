class UsersController < ApplicationController
  wrap_parameters :user, include: [:name, :email, :password, :password_confirmation]

 # def new
 #   @user = User.new
  #end

  # GET /users
  # GET /users.json
  def index    
    @user_aux = authenticate
    if(@user_aux.nil?)
      respond_to do |format|
      format.json {render json: { 
       meta: {code: 401 , error_message: "Unauthorized"}
      }}
    end
    else    
      @users = User.all
    end
  end


  # GET /users/1
  # GET /users/1.json
  def show
    @user_aux = authenticate
    if(@user_aux.nil?)
      respond_to do |format|
      format.json {render json: { 
       meta: {code: 401 , error_message: "Unauthorized"}
      }}
    end
    else
      @user = User.find_by_id(params[:id])
      render json: {
      meta: {code: 404, error_type: "User not found"}
      } if @user.nil?
    end
  end

  # POST /users
  # POST /users.json
def create
    @user = User.new(user_params)
    respond_to do |format|
    if @user.save
      self_aux = String.new
      self_aux = "/users/" + @user.id.to_s
      self_array = {'href' => self_aux}
      array_links = Array.new
      array_links = {'self' => self_array}
      format.json {render json: {meta: {code: 201, message: "User created"},
      _links: array_links}}
    else 
      format.json {render json: {meta: {code: 403, error_type: @user.errors}}}
    end
  end
end

#def show
 #   begin
  #    @submissions = Submission.where("user_id=?", @user.id).order("created_at DESC")
   #   @comments = Comment.where("user_id=?", @user.id).order("created_at DESC")
    #rescue ActiveRecord::RecordNotFound
     # render :json => { "status" => "404", "error" => "User not found."}, status: :not_found
    #end
  #end


  #def create
  #  @user = User.new(user_params)
  #  if @user.save
  #    log_in @user
  #    redirect_to issues_path
  #  else 
  #    render 'new'
  #  end
  #end

  #private

  #  def user_params
  #          params.require(:user).permit(:name, :email, :password, :password_confirmation)
  #  end
  def user_params
           params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
