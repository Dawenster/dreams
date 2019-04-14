require 'rails_helper'

RSpec.describe DreamsController, type: :controller do
  let(:user) { Fabricate(:user) }
  let(:element) { Fabricate(:element) }
  let(:dream) { Fabricate(:dream, user: user) }

  describe '#random' do
    before do
      dream.elements << element
    end

    it 'returns all dreams' do
      res = get(:random)
      data = JSON.parse(res.body).fetch('data')

      expect(data.fetch('id')).to eq(dream.id)
      expect(data.fetch('attributes').fetch('title')).to eq(dream.title)

      relationships = data.fetch('relationships')
      user_data = relationships.fetch('user').fetch('data')
      elements_data = relationships.fetch('elements').fetch('data')

      expect(user_data.fetch('id')).to eq(user.id)
      expect(elements_data.map{|e| e.fetch('id')}.include?(element.id))
        .to eq(true)
    end
  end
end
