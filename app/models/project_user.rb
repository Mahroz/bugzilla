class ProjectUser < ApplicationRecord
  include Filterable

  belongs_to :project
  belongs_to :user
end
