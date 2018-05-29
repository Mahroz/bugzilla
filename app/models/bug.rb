class Bug < ApplicationRecord
  include Filterable
  has_one_attached :bug_image

  belongs_to :project
  belongs_to :developer, :class_name => 'User', :foreign_key => 'developer_id', optional: true
  belongs_to :creator,  :class_name => 'User', :foreign_key => 'creator_id'
end
