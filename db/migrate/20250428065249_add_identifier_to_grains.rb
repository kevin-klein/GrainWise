class AddIdentifierToGrains < ActiveRecord::Migration[7.0]
  def change
    add_column :grains, :identifier, :string
  end
end
