class IssuesController < ApplicationController
  before_action  only: [:show, :edit, :update, :destroy]

  # GET /issues
  # GET /issues.json
  def index

    @user_aux = authenticate
    if(@user_aux.nil?)
      respond_to do |format|
      format.json {render json: { 
       meta: {code: 401, error_message: "Unauthorized"}
      }}
    end
    else
      @issues = Issue.all
      filtered = false
      if params[:status]
        @status = Status.where('lower(name) = ?', params[:status].downcase).first 
        @issues = @issues & Issue.where(status_id: @status.id)
        filtered = true
      end
      if params[:kind]
        @kind = Kind.where('lower(name) = ?', params[:kind].downcase).first 
        @issues = @issues & Issue.where(kind_id: @kind.id)
        filtered = true
      end
      if params[:priority]
        @priority = Priority.where('lower(name) = ?', params[:priority].downcase).first 
        @issues = @issues & Issue.where(priority_id: @priority.id)
        filtered = true
      end

      if params[:watching]
        @user = User.where('lower(email) = ?', params[:watching].downcase).first
        if(!@user.nil?)
        @issues = @issues & Issue.joins(:watches).where('watches.user_id' => @user)
        filtered = true
      end
      end

      if params[:assigned]
        @user = User.where('lower(email) = ?', params[:assigned].downcase).first 
        if(!@user.nil?)
        @issues = @issues & Issue.where(user_id_2: @user.id)
        filtered = true
      end
      end

      @issues = filtered ? @issues.uniq : Issue.all


      array_iss = @issues
      array_total = Array.new;
      array_iss.each {|iss|   
        array = iss.comments
          array2 = Array.new;
          array.each {|x| 
            usr = { 'User' => User.select("id,name,email").find_by_id(x.user_id)}
            foo = {'id' => x.id,
                    'text' => x.description,
                    'created_at' => x.created_at,
                    'user_creator' => usr}
            array2.push(JSON[foo.to_json])
          }
      
        c_t = { 'count' => iss.comments.count,
                'data' => array2}

        usr1 = { 'User' => User.select("id,name,email").find_by_id(iss.user_id)}
        usr2 = { 'User' => User.select("id,name,email").find_by_id(iss.user_id_2)}
        issue_ = {'id' => iss.id,
                    'title' => iss.title,
                    'description' => iss.description,
                    'kind' => Kind.find_by_id(iss.kind_id).name,
                    'priority' => Priority.find_by_id(iss.priority_id).name,
                    'status' => Status.find_by_id(iss.status_id).name,
                    'spam' => iss.spam,
                    'created_at' => iss.created_at,
                    'updated_at' => iss.updated_at,
                    'comments' => c_t,
                    'user_creator' => usr1,
                    'user_assignee' => usr2}

        issue_t = { 'Issue' => issue_}


          array_total.push(JSON[issue_t.to_json])


        }

        self_aux = String.new
        self_aux = "/issues"
        self_array = {'href' => self_aux}
        array_links = Array.new
        array_links = {'self' => self_array}

        respond_to do |format|
        format.json {render json: {
        meta: {code: 200, message: "OK"},
        data: {issues: array_total},
        _links: array_links}}
         end
      @watch = Watch.new
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @user_aux = authenticate
    if(@user_aux.nil?)
      respond_to do |format|
      format.json {render json: { 
       meta: {code: 401 , error_message: "Unauthorized"}
      }}
    end
    else

    @issue = Issue.find_by_id(params[:id])
    if(Issue.find_by_id(params[:id]))

  
      array = @issue.comments
      array2 = Array.new;
      array.each {|x| 
        usr = { 'User' => User.select("id,name,email").find_by_id(x.user_id)}
        foo = {'id' => x.id,
                'text' => x.description,
                'created_at' => x.created_at,
                'user_creator' => usr}
        array2.push(JSON[foo.to_json])
      }


    self_aux = String.new
    self_aux = "/issues/" + params[:id]
    self_aux2 = String.new
    self_aux2 = "/users/" + @issue.user_id.to_s
    self_aux3 = String.new
    if(!@issue.user_id_2.nil?)
      self_aux3 = "/users/" + @issue.user_id_2.to_s
    end
    self_array = {'href' => self_aux}
    creator_array = {'href' => self_aux2}
    assignee_array = {'href' => self_aux3}
    array_links = Array.new
    array_links = {'self' => self_array,
                   'user_creator' => creator_array,
                   'user_assignee' => assignee_array}



      respond_to do |format|
      format.json {render json: {
      meta: {code: 200, message: "Loaded issue"},
      data: {issue: {id: @issue.id, title: @issue.title, description: @issue.description, kind: Kind.find_by_id(@issue.kind_id).name, priority: Priority.find_by_id(@issue.priority_id).name, status: Status.find_by_id(@issue.status_id).name, spam:@issue.spam, created_at: @issue.created_at, updated_at:@issue.updated_at},
         comments: {count: @issue.comments.count, data: array2},
         user_creator: {User: User.select("id,name,email").find_by_id(@issue.user_id)},
         user_assignee: {User: User.select("id,name,email").find_by_id(@issue.user_id_2)}},
         _links: array_links}}
      end
    else
    respond_to do |format|
      format.json {render json: { 
       meta: {code: 404, error_message: "Issue not found"}
      }}
    end
    end
    @comment = Comment.new
    @comments = Comment.where issue_id: params[:id]
    @comments = [] if @comments.nil?
    @vote = Vote.new
    @watch = Watch.new
    @status = Status.all
  end
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.json
  def create
    @user_aux = authenticate
    if(@user_aux.nil?)
      respond_to do |format|
      format.json {render json: { 
       meta: {code: 401, error_message: "Unauthorized"}
      }}
    end
    else
      request_parameters = JSON.parse(request.body.read.to_s)
      title = request_parameters["title"]
      kind = request_parameters["kind"]
      priority = request_parameters["priority"]
      description = request_parameters["description"]
      assignee_id = request_parameters["assignee-id"]
      if !User.where(id: assignee_id).first
         respond_to do |format| 
         format.json {render json: {  
         meta: {code: 404, error_message: "A user with the specified assignee id was not found"} 
         }} 
       end  
      else
        @issue = Issue.create(user_id:  @user_aux.id, user_id_2: assignee_id, title: title, description: description, kind_id:  Kind.find_by(name: kind).id, priority_id: Priority.find_by(name: priority).id, status_id: 1, spam: false)
        respond_to do |format|
          if @issue.save
            watch = Watch.new
            watch.issue_id = @issue.id;
            watch.user_id = @issue.user_id;
            watch.save
            if (!@issue.user_id_2.nil?)
              if (@issue.user_id != @issue.user_id_2)
                watch2 = Watch.new
                watch2.issue_id = @issue.id;
                watch2.user_id = @issue.user_id_2;
                watch2.save
              end
            end

        self_aux = String.new
        self_aux = "/issues/" + @issue.id.to_s
        self_aux2 = String.new
        self_aux2 = "/users/" + @issue.user_id.to_s
        self_aux3 = String.new
        if(!@issue.user_id_2.nil?)
          self_aux3 = "/users/" + @issue.user_id_2.to_s
        end
        self_array = {'href' => self_aux}
        creator_array = {'href' => self_aux2}
        assignee_array = {'href' => self_aux3}
        array_links = Array.new
        array_links = {'self' => self_array,
                       'user_creator' => creator_array,
                       'user_assignee' => assignee_array}

            format.json {render json: {
          meta: {code: 201, message: "Issue created"},
          data: {issue: {id: @issue.id, title: @issue.title, description: @issue.description, kind: Kind.find_by_id(@issue.kind_id).name, priority: Priority.find_by_id(@issue.priority_id).name, status: Status.find_by_id(@issue.status_id).name, spam:@issue.spam, created_at: @issue.created_at, updated_at:@issue.updated_at},
             comments: {count: @issue.comments.count, data: @issue.comments},
             user_creator: {User: User.select("id,name,email").find_by_id(@issue.user_id)},
             user_assignee: {User: User.select("id,name,email").find_by_id(@issue.user_id_2)}},
             _links: array_links}}
          else
            format.json {render json: { 
           meta: {code: 403, error_message: "Forbidden"}}}
          end
        end
      end
    end
  end

  def delete_attachment
    @issue = Issue.find(params[:id])
    @issue.attachment = nil
    @issue.save
    redirect_to @issue
end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
      @user_aux = authenticate
      if(@user_aux.nil?)
        respond_to do |format|
        format.json {render json: { 
         meta: {code: 401 , error_message: "Unauthorized"}
        }}
      end
      else
          request_parameters = JSON.parse(request.body.read.to_s)
          action = request_parameters["action"]
          title = request_parameters["issue"]["title"]
          kind = request_parameters["issue"]["kind"]
          priority = request_parameters["issue"]["priority"]
          description = request_parameters["issue"]["description"]
          assignee_id = request_parameters["issue"]["assignee-id"]
          if (action.nil? && !assignee_id.nil? && !User.where(id: assignee_id).first)
           respond_to do |format| 
           format.json {render json: {  
           meta: {code: 404, error_message: "A user with the specified assignee id was not found"} 
           }} 
           end
         else
          @issue = Issue.find_by_id(params[:id])
        if(Issue.find_by_id(params[:id]))
          if(action == "vote")
            if (Vote.find_by(user_id: @user_aux.id, issue_id: (params[:id])).nil?)
              vote = Vote.create(issue_id: (params[:id]), user_id: @user_aux.id);
              vote.save
            end
          elsif (action == "unvote")
            if (!Vote.find_by(user_id: @user_aux.id, issue_id: (params[:id])).nil?)
              vote = Vote.find_by(issue_id: (params[:id]), user_id: @user_aux.id);
              vote.delete
            end
          elsif (action == "watch")
            if (Watch.find_by(user_id: @user_aux.id, issue_id: (params[:id])).nil?)
              watch = Watch.create(issue_id: (params[:id]), user_id: @user_aux.id);
              watch.save
            end
          elsif (action == "unwatch")
            if (!Watch.find_by(user_id: @user_aux.id, issue_id: (params[:id])).nil?)
              watch = Watch.find_by(issue_id: (params[:id]), user_id: @user_aux.id);
              watch.delete
            end
          elsif (action == "mark as spam")
              @issue.spam = true;
              @issue.save
          elsif (action == "unmark spam")
            @issue.spam = false;
            @issue.save    
          else
              @issue.title= title;
              @issue.kind_id = Kind.find_by(name: kind).id;
              @issue.priority_id = Priority.find_by(name: priority).id;
              if(!description.nil?)
               @issue.description = description;
              end
              if(!assignee_id.nil?)
                @issue.user_id_2 = assignee_id;
               end
              @issue.save
          end

          array = @issue.comments
          array2 = Array.new;
          array.each {|x| 
            usr = { 'User' => User.select("id,name,email").find_by_id(x.user_id)}
            foo = {'id' => x.id,
                    'text' => x.description,
                    'created_at' => x.created_at,
                    'user_creator' => usr}
            array2.push(JSON[foo.to_json])
          }

          self_aux = String.new
          self_aux = "/issues/" + params[:id]
          self_aux4 = String.new
          self_aux4 = "/users/" + @user_aux.id.to_s
          self_aux2 = String.new
          self_aux2 = "/users/" + @issue.user_id.to_s
          self_aux3 = String.new
           if(!@issue.user_id_2.nil?)
            self_aux3 = "/users/" + @issue.user_id_2.to_s
         end
          self_array = {'href' => self_aux}
          editor_array = {'href' => self_aux4}
          creator_array = {'href' => self_aux2}
          assignee_array = {'href' => self_aux3}
          array_links = Array.new
          array_links = {'self' => self_array,
                       'editor' => editor_array,
                       'user_creator' => creator_array,
                       'user_assignee' => assignee_array}


          respond_to do |format|
          format.json {render json: {
          meta: {code: 200, message: "Loaded issue"},
          data: {issue: {id: @issue.id, title: @issue.title, description: @issue.description, kind: Kind.find_by_id(@issue.kind_id).name, priority: Priority.find_by_id(@issue.priority_id).name, status: Status.find_by_id(@issue.status_id).name, spam:@issue.spam, created_at: @issue.created_at, updated_at:@issue.updated_at},
             comments: {count: @issue.comments.count, data: array2},
             user_creator: {User: User.select("id,name,email").find_by_id(@issue.user_id)},
             user_assignee: {User: User.select("id,name,email").find_by_id(@issue.user_id_2)}},
             _links: array_links}}
          end
        else
        respond_to do |format|
          format.json {render json: { 
           meta: {code: 404, error_message: "Issue not found"}
          }}
        end
        end  
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @user_aux = authenticate
    if(@user_aux.nil?)
      respond_to do |format|
      format.json {render json: { 
       meta: {code: 401, error_message: "Unauthorized"}
      }}
    end
    else
      @issue = Issue.find_by_id(params[:id])
      if(Issue.find_by_id(params[:id]))
        @issue.destroy

        self_aux = String.new
        self_aux = "/issues/" + params[:id]
        self_aux3 = String.new
        self_aux3 = "/users/" + @user_aux.id.to_s
        self_aux2 = String.new
        self_aux2 = "/issues"
        self_array = {'href' => self_aux}
        user_array = {'href' => self_aux3}
        issues_array = {'href' => self_aux2}

        array_links = Array.new
        array_links = {'self' => self_array,
                      'user' => user_array,
                     'issues' => issues_array}

        respond_to do |format|
        format.json {render json: {meta: {code: 200, message: "Issue deleted"}, _links: array_links}}
        end
      else
        respond_to do |format|
        format.json {render json: {meta: {code: 404, error_message: "Issue not found"}}}
        end
      end
    end
  end

  #POST /issues/1/comments
  #POST /issues/1/comments
  def comment_issue
    @user_aux = authenticate
    if(@user_aux.nil?)
      respond_to do |format|
      format.json {render json: { 
       meta: {code: 401, error_message: "Unauthorized"}
      }}
    end
    else
    request_parameters = JSON.parse(request.body.read.to_s)
    text = request_parameters["text"]
    @issue = Issue.find_by_id(params[:id])
    if(Issue.find_by_id(params[:id]))
      comment = Comment.create(description: text, issue_id: @issue.id, user_id: @user_aux.id)
      comment.save

      self_aux = String.new
      self_aux = "/issues/" + params[:id] + "/comments"
      self_aux4 = String.new
      self_aux4 = "/comments/" + comment.id.to_s
      self_aux2 = String.new
      self_aux2 = "/users/" + comment.user_id.to_s
      self_aux3 = String.new
      self_aux3 = "/issues/" + comment.issue_id.to_s
      self_array = {'href' => self_aux}
      comment_array = {'href' => self_aux4}
      user_array = {'href' => self_aux2}
      issue_array = {'href' => self_aux3}
      array_links = Array.new
      array_links = {'self' => self_array,
                   'comment' => comment_array,
                   'issue' => issue_array,
                   'user' => user_array}

      respond_to do |format|
      format.json { render json: {
          meta: {code: 201, message: "Comment created"},
          data: {comment: {id: comment.id, text: comment.description, created_at: comment.created_at,
            user_creator: {User: User.select("id,name,email").find_by_id(comment.user_id)}}},
          _links: array_links}}
      end
    else
      respond_to do |format|
      format.json {render json: {meta: {code: 404, error_message: "Issue not found"}}}
      end
    end
  end
      
  end






  def status_edit
    issue = Issue.find(params[:issue_id])
    issue.update(status_id: params[:status_id])
    redirect_to request.referer
  end

  def spam
    issue = Issue.find(params[:issue_id])
    issue.update(spam: !issue.spam)
    redirect_to request.referer
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:user_id, :user_id_2, :title, :description, :kind_id, :priority_id, :status_id, :spam, :attachment)
    end
    def issue_new_params
      params.require(:issue).permit(:title, :kind, :priority, :description, :assignee_id)
    end
end
