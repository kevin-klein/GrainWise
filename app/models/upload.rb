# == Schema Information
#
# Table name: uploads
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#  public     :boolean          default(FALSE), not null
#  name       :string
#  site_id    :integer
#  strain_id  :integer
#  view       :integer
#
class Upload < ApplicationRecord
  has_many :upload_items, dependent: :destroy
  has_many :figures, through: :pages

  belongs_to :site, optional: true
  belongs_to :strain, optional: true

  has_one_attached :zip

  def short_description
    "#{author} #{year}"
  end

  def graves
    figures.filter { _1.is_a?(Grave) }
  end
end
