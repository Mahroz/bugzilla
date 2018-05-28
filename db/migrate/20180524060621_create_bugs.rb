class CreateBugs < ActiveRecord::Migration[5.2]
  def change
    create_table :bugs do |t|
      t.string :title
      t.datetime :deadline
      t.string :image
      t.integer :issue_type
      t.integer :status
      t.integer :project_id
      t.integer :creator_id
      t.integer :developer_id

      t.timestamps
    end
  end
end
