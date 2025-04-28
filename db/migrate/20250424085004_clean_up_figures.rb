class CleanUpFigures < ActiveRecord::Migration[7.0]
  def change
    change_table :figures do |t|
      t.remove :angle
      t.remove :site_id
      t.remove :validated
      t.remove :verified
      t.remove :disturbed
      t.remove :deposition_type
      t.remove :contour
      t.jsonb :contour
      t.remove :percentage_scale
      t.remove :page_size
      t.remove :bounding_box_angle
      t.remove :bounding_box_width
      t.remove :bounding_box_height
      t.remove :contour_info
    end
  end
end
