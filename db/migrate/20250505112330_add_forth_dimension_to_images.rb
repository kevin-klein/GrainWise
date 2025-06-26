class AddForthDimensionToImages < ActiveRecord::Migration[7.0]
  def change
    change_table :grains do |t|
      t.references :ts, foreign_key: {to_table: "figures"}
    end
  end
end
