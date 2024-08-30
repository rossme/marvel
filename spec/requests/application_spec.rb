# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#sign_in_fake_user' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'should find a fake user' do
      expect(user).to be_a(User)
      expect(user).to be_valid
    end

    it 'should sign in a fake user' do
      expect(subject.current_user).to eq(user)
    end
  end
end
