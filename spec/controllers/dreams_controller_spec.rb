require 'rails_helper'

RSpec.describe DreamsController, type: :controller do
  let(:user) { Fabricate(:user) }
  let!(:dream) { Fabricate(:dream, user: user) }

  describe '#random' do
    it 'returns all dreams' do
      res = get(:random)
      result = JSON.parse(res.body)

      expect(result.fetch('id')).to eq(dream.id)
    end
  end
end
