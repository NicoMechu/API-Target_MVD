# == Schema Information
#
# Table name: targets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  topic_id   :integer
#  lat        :float
#  lng        :float
#  radius     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#
# Indexes
#
#  index_targets_on_deleted_at  (deleted_at)
#

class Target < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user
  belongs_to :topic
  
  validates :lat, :lng, :radius, presence: true
  validate :not_exceeded_limit?

  scope :shared_topic, -> (target) { where(:topic => target.topic).where.not(user_id: target.user_id) }

  def not_exceeded_limit?
    if !self.user.nil?  &&  self.user.targets(:reload).count >= 10
      errors.add(:limit, "Targets limit exceeded")
    end
  end
end
