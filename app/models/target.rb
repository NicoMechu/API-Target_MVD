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

  has_many :matches,         class_name: 'MatchConversation', foreign_key: 'target_a_id'
  has_many :inverse_matches, class_name: 'MatchConversation', foreign_key: 'target_b_id'
  
  after_destroy :inactivate_matches

  validates :lat, :lng, :radius, presence: true
  validate :not_exceeded_limit?, on: :create

  scope :shared_topic, -> (target) { where(:topic => target.topic).where.not(user_id: target.user_id) }

  def not_exceeded_limit?
    if !self.user.nil?  &&  self.user.targets(:reload).count >= 10
      errors.add(:limit, "Targets limit exceeded")
    end
  end

  def all_matches
    MatchConversation.where("target_a_id = :target or target_b_id = :target", { target: id } )
  end

  def inactivate_matches
    self.all_matches.each do |match|
      match.target_a_id = nil
      match.target_b_id = nil
      match.save
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
      match = MatchConversation.new(user_a: user, 
        user_b: matching_target.user, 
        topic: topic, 
        title_a:title, 
        title_b:matching_target.title,
        target_a_id:id,
        target_b_id:matching_target.id
      )
      match.save && matches << match
    end
    matches
  end
end
