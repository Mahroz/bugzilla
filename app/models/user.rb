class User < ApplicationRecord
  has_many :projects, :class_name => 'Project', :foreign_key => 'manager_id'
  has_many :associated_projects, :class_name => 'ProjectUser'
  has_many :projects, :through => :associated_projects
  has_many :bugs_created,  :class_name => 'Bug', :foreign_key => 'creator_id'
  has_many :bugs_worked,  :class_name => 'Bug', :foreign_key => 'developer_id'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
