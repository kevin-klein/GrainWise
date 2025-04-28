# == Schema Information
#
# Table name: figures
#
#  id                   :bigint           not null, primary key
#  upload_item_id       :bigint           not null
#  x1                   :integer
#  x2                   :integer
#  y1                   :integer
#  y2                   :integer
#  type                 :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  area                 :float
#  perimeter            :float
#  milli_meter_ratio    :float
#  parent_id            :integer
#  identifier           :string
#  width                :float
#  height               :float
#  text                 :string
#  upload_id            :integer
#  manual_bounding_box  :boolean          default(FALSE)
#  probability          :float
#  real_world_area      :float
#  real_world_width     :float
#  real_world_height    :float
#  real_world_perimeter :float
#  strain_id            :integer
#  control_points       :integer          is an Array
#  anchor_points        :integer          is an Array
#  view                 :integer
#  contour              :jsonb
#
class Text < Figure
end
