# == Schema Information
#
# Table name: push_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  push_token :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe PushToken, type: :model do
  it { should validate_presence_of(:push_token) }
end
