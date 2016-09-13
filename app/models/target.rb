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
#  title      :string
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
  validate :not_exceeded_limit?, on: :create

  scope :shared_topic, -> (target) { where(:topic => target.topic).where.not(user_id: target.user_id) }

  def not_exceeded_limit?
    if !self.user.nil?  &&  self.user.targets(:reload).count >= 10
      errors.add(:limit, "Targets limit exceeded")
    end
  end

  def matches

    # Query to find targets present in a square circumscribed around a circle whis radius is equal to the addition
    # of the raidius of both targets.
    box_query     = "earth_box(ll_to_earth(#{lat},#{lng}),"\
                    "(#{radius} + radius)) @> ll_to_earth(lat, lng)"
    # Query to find alltargets present in a radius equal to the addition of the raidius of both targets.
    # This query is more ineficient thant the otherone, the box query allows targets which doesn't corresponds. 
    # So, the box query creates a primary filter and the radius query refines it.
    radius_query  = "earth_distance(ll_to_earth(#{lat},#{lng}),"\
                    " ll_to_earth(lat, lng)) <= (#{radius} + radius)"

    matching_targets = Target.shared_topic(self).where(box_query).where(radius_query)
    
    matches = []
    matching_targets.each do |matching_target|
      match = MatchConversation.new(user_a: user, user_b: matching_target.user, topic: topic)
      match.save && matches << match
    end
    matches
  end
end
