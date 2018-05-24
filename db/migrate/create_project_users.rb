class CreateProjectUsers < ActiveRecord::Migration[5.2]
  def self.up
    create_table 'project_users', :id => false do |t|
      t.column :project_id, :integer
      t.column :user_id, :integer
    end
  end
end
