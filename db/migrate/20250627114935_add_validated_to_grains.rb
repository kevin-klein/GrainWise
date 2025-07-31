class AddValidatedToGrains < ActiveRecord::Migration[7.0]
  def change
    add_column :grains, :validated, :boolean
  end
end
