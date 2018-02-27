json.array!(@users) do |user|
  json.extract! user, :id, :name, :password, :email, :address, :phone, :is_admin, :is_deleted
  json.url user_url(user, format: :json)
end
