class AddFixedScalesToUploads < ActiveRecord::Migration[7.0]
  def change
    add_column :uploads, :scale_pixels, :integer
    add_column :uploads, :scale_mm_distance, :decimal
  end
end
