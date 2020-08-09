json.extract! song, :id, :name, :description, :song_url, :albumn_id, :year, :user_id, :created_at, :updated_at
json.url song_url(song, format: :json)
