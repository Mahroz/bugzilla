class RemoveImageFieldToUseActiveStorage < ActiveRecord::Migration[5.2]
  def change
    remove_column :bugs, :image
  end
end
