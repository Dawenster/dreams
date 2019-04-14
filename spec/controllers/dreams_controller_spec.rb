require 'rails_helper'

RSpec.describe DreamsController, type: :controller do
  let(:user) { Fabricate(:user) }
  let(:element) { Fabricate(:element) }
  let(:dream) { Fabricate(:dream, user: user) }

  before do
    dream.elements << element
  end

  describe '#show' do
    it 'returns dream' do
      res = get(:show, params: { id: dream.id })
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

  describe '#random' do
    it 'returns random dream' do
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
