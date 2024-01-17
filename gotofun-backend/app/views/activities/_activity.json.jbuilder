json.extract! activity, :id, :title, :description, :lat, :long, :created_at, :updated_at
json.url activity_url(activity, format: :json)
