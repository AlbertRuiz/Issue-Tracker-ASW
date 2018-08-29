json.set! "data" do
	json.array!(@users) do |user|
  		json.extract! user, :id, :name, :email
  	end
end
json.set! "meta" do
	json.code 200
	json.status "Ok"
	json.message "Successful"
end
json.set! "_links" do
	json.set! "self" do
		json.array!(@users) do |user|
      		json.href "/users/" + user.id.to_s
      	end
    end
end