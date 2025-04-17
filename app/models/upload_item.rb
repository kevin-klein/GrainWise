# == Schema Information
#
# Table name: upload_items
#
#  id             :bigint           not null, primary key
#  publication_id :bigint           not null
#  image_id       :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class UploadItem < ApplicationRecord
  belongs_to :upload
  belongs_to :image, dependent: :destroy
  has_many :figures, inverse_of: :page, dependent: :destroy
end
