json.extract! project, :id, :title, :description, :manager_id, :start_date, :created_at, :updated_at
json.url project_url(project, format: :json)
