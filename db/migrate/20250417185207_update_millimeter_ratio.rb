class UpdateMillimeterRatio < ActiveRecord::Migration[7.0]
  def change
    rename_column :figures, :meter_ratio, :milli_meter_ratio
  end
end
