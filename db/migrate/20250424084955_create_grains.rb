class CreateGrains < ActiveRecord::Migration[7.0]
  def change
    create_table :grains do |t|
      t.references :site, null: false, foreign_key: true
      t.references :strain, null: false, foreign_key: true
      t.references :dorsal, foreign_key: {to_table: "figures"}
      t.references :ventral, foreign_key: {to_table: "figures"}

      t.timestamps
    end
  end
end
