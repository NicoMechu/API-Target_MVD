# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  label      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  icon       :string
#

class Topic < ActiveRecord::Base
  mount_uploader :icon, AvatarUploader

  has_many :targets, dependent: :destroy
  
  validates :label, presence: true

  def to_s
    label
  end

  def as_json(options={})
    { 
      id:     id,
      label:  label, 
      icon:   icon.url
    }
  end
end
