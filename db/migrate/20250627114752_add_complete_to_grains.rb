class AddCompleteToGrains < ActiveRecord::Migration[7.0]
  def change
    add_column :grains, :complete, :boolean
  end
end
