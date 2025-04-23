class UpdateFigureNullable < ActiveRecord::Migration[7.0]
  def change
    change_table :figures do |t|
      t.change :x1, :int, null: true
      t.change :y1, :int, null: true
      t.change :x2, :int, null: true
      t.change :y2, :int, null: true
    end
  end
end
