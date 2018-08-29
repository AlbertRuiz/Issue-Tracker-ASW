class VotesController < ApplicationController
  def index
    render text: 'ohai'
  end

  # POST /votes
  # POST /votes.json
  def create
    vote = Vote.create(vote_params)
    issue = Issue.find vote[:issue_id]

    vote.save
    redirect_to issue
  end

  def destroy
    Vote.where(:user_id => params[:user_id], :issue_id => params[:issue_id]).delete_all
    issue = Issue.find params[:issue_id]
    redirect_to issue
  end

  def vote_params
    params.require(:vote).permit(:issue_id, :user_id)
  end

end
