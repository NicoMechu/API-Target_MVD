# == Schema Information
#
# Table name: messages
#
#  id                    :integer          not null, primary key
#  text                  :string
#  user_id               :integer
#  match_conversation_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should validate_presence_of(:text) }
end
