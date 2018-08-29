class WatchesController < ApplicationController 
  def index 
    render text: 'ohai' 
  end 
 
  # POST /watches 
  # POST /watches.json 
  def create 
    watch = Watch.create(watch_params)
    watch.save
    redirect_to request.referer
  end
 
  def destroy
    Watch.where(:user_id => params[:user_id], :issue_id => params[:issue_id]).delete_all
    redirect_to request.referer
  end 
 
  def watch_params 
    params.require(:watch).permit(:issue_id, :user_id)
  end 
 
end 