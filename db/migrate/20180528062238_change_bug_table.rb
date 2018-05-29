class ChangeBugTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :bugs, :type, :integer
    add_column :bugs, :issue_type, :integer
  end
end
