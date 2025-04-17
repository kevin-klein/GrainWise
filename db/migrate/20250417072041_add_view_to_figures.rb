class AddViewToFigures < ActiveRecord::Migration[7.0]
  def change
    add_column :uploads, :view, :integer
    add_column :figures, :view, :integer
  end
end
