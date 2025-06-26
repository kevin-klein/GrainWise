# == Schema Information
#
# Table name: grains
#
#  id         :bigint           not null, primary key
#  site_id    :bigint           not null
#  strain_id  :bigint           not null
#  dorsal_id  :bigint
#  ventral_id :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  identifier :string
#  lateral_id :bigint
#  ts_id      :bigint
#
class Grain < ApplicationRecord
  belongs_to :site, optional: true
  belongs_to :strain, optional: true

  belongs_to :dorsal, class_name: "GrainFigure", foreign_key: "dorsal_id", optional: true
  belongs_to :lateral, class_name: "GrainFigure", foreign_key: "lateral_id", optional: true
  belongs_to :ventral, class_name: "GrainFigure", foreign_key: "ventral_id", optional: true
  belongs_to :ts, class_name: "GrainFigure", foreign_key: "ts_id", optional: true
end
