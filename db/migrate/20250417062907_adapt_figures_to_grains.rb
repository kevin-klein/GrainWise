class AdaptFiguresToGrains < ActiveRecord::Migration[7.0]
  def change
    remove_column :figures, :control_point_1_x
    remove_column :figures, :control_point_1_y
    remove_column :figures, :control_point_2_x
    remove_column :figures, :control_point_2_y
    remove_column :figures, :control_point_3_x
    remove_column :figures, :control_point_3_y
    remove_column :figures, :control_point_4_x
    remove_column :figures, :control_point_4_y

    remove_column :figures, :anchor_point_1_x
    remove_column :figures, :anchor_point_1_y
    remove_column :figures, :anchor_point_2_x
    remove_column :figures, :anchor_point_2_y
    remove_column :figures, :anchor_point_3_x
    remove_column :figures, :anchor_point_3_y
    remove_column :figures, :anchor_point_4_x
    remove_column :figures, :anchor_point_4_y

    create_table :strains do |t|
      t.string :name
    end

    add_column :figures, :strain_id, :integer
    add_column :figures, :control_points, :integer, array: true
    add_column :figures, :anchor_points, :integer, array: true
  end
end
