# == Schema Information
#
# Table name: figures
#
#  id                   :bigint           not null, primary key
#  upload_item_id       :bigint           not null
#  x1                   :integer          not null
#  x2                   :integer          not null
#  y1                   :integer          not null
#  y2                   :integer          not null
#  type                 :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  area                 :float
#  perimeter            :float
#  meter_ratio          :float
#  angle                :float
#  parent_id            :integer
#  identifier           :string
#  width                :float
#  height               :float
#  text                 :string
#  site_id              :bigint
#  validated            :boolean          default(FALSE), not null
#  verified             :boolean          default(FALSE), not null
#  disturbed            :boolean          default(FALSE), not null
#  contour              :text             default([]), not null
#  deposition_type      :integer          default(0), not null
#  upload_id            :integer
#  percentage_scale     :integer
#  page_size            :integer
#  manual_bounding_box  :boolean          default(FALSE)
#  bounding_box_angle   :integer
#  bounding_box_width   :integer
#  bounding_box_height  :integer
#  probability          :float
#  contour_info         :jsonb
#  real_world_area      :float
#  real_world_width     :float
#  real_world_height    :float
#  real_world_perimeter :float
#  strain_id            :integer
#  control_points       :integer          is an Array
#  anchor_points        :integer          is an Array
#  view                 :integer
#
class Grain < Figure

end
