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
class GrainFigure < Figure
  has_one :scale, dependent: :destroy, foreign_key: "parent_id", class_name: "Scale", inverse_of: :grain_figure
  has_one :dorsal_grain, class_name: "Grain", foreign_key: "ventral_id"
  has_one :ventral_grain, class_name: "Grain", foreign_key: "dorsal_id"
  has_one :lateral_grain, class_name: "Grain", foreign_key: "lateral_id"

  with_unit :area, square: true
  with_unit :perimeter
  with_unit :width
  with_unit :height
  with_unit :bounding_box_width
  with_unit :bounding_box_height

  with_unit :normalized_width
  with_unit :normalized_height

  def grain
    dorsal_grain || ventral_grain || lateral_grain
  end
end
