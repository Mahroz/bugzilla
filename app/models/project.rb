class Project < ApplicationRecord
  include Filterable

  belongs_to :manager, :class_name => 'User', :foreign_key => 'manager_id'
  has_many :associated_users, :class_name => 'ProjectUser', dependent: :delete_all
  has_many :users, :through => :associated_users
  has_many :bugs , dependent: :delete_all

  scope :starts_with, -> (title) { where("title like ?", "#{title}%")}
end
