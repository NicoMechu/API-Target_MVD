# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  label      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Topic < ActiveRecord::Base
  has_many :targets, dependent: :destroy
  
  validates_presence_of :label

  def to_s
    label
  end

end
