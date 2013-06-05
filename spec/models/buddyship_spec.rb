require 'spec_helper'

describe Buddyship do
  it 'has different user_id and buddy_id' do
    user = create :user

    Buddyship.new(user: user, buddy: user).should_not be_valid
  end
end
