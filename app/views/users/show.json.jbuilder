json.set! "data" do
	json.extract! @user, :id, :name, :email
end
json.set! "meta" do
	json.code 200
	json.status "Ok"
	json.message "Successful"
end
json.set! "_links" do
  json.set! "self" do
    json.href "/users/"+ @user.id.to_s
  end
end
