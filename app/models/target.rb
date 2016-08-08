# == Schema Information
#
# Table name: targets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  topic_id   :integer
#  lat        :float
#  lng        :float
#  radio      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Target < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :topic, dependent: :destroy

  validates_presence_of :lat, :lng, :radio
end