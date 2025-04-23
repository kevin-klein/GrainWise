class RenameUploadItemPublicationId < ActiveRecord::Migration[7.0]
  def change
    rename_column :upload_items, :publication_id, :upload_id
  end
end
