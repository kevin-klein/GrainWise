class AddUploadToGrains < ActiveRecord::Migration[7.0]
  def change
    add_reference :grains, :upload
  end
end
