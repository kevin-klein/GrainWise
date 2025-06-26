class AddFeatureToUploads < ActiveRecord::Migration[7.0]
  def change
    change_table :uploads do |t|
      t.string :feature
      t.string :sample
    end
  end
end
