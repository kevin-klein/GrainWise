class AddLateralToGrains < ActiveRecord::Migration[7.0]
  def change
    change_table :grains do |t|
      t.references :lateral, foreign_key: {to_table: "figures"}
    end
  end
end
