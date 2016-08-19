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

require 'rails_helper'

RSpec.describe Target, type: :model do
    it { should belong_to(:user)  }
    it { should belong_to(:topic)  }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lng) }
    it { should validate_presence_of(:radius) }
end
