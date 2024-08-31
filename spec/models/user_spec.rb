# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User model' do
    it 'should have a valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'should validate uniqueness of email' do
      create(:user, email: 'email@example.com')
      expect(build(:user, email: 'email@example.com')).to_not be_valid
    end
  end
end
