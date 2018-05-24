class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.integer :manager_id
      t.date :start_date

      t.timestamps
    end
  end
end
