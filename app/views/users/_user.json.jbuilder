json.extract! user, :id, :username, :email, :phone_no, :created_at, :updated_at
json.url user_url(user, format: :json)
