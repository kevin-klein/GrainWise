class RenamePublications < ActiveRecord::Migration[7.0]
  def change
    rename_table :publications, :uploads

    change_table :uploads do |t|
      t.remove :author
      t.remove :year
      t.remove :title
      t.string :name
      t.integer :site_id
      t.integer :strain_id
    end

    rename_table :pages, :upload_items

    change_table :upload_items do |t|
      t.remove :number
    end

    rename_column :figures, :publication_id, :upload_id
    rename_column :figures, :page_id, :upload_item_id
  end
end
