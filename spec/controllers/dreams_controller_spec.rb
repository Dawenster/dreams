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

      attributes = data.fetch('attributes')

      expect(attributes.fetch('title')).to eq(dream.title)
      expect(attributes.fetch('description')).to eq(dream.description)
      expect(attributes.fetch('show_description')).to eq(dream.show_description)

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

      attributes = data.fetch('attributes')

      expect(attributes.fetch('title')).to eq(dream.title)
      expect(attributes.fetch('description')).to eq(dream.description)
      expect(attributes.fetch('show_description')).to eq(dream.show_description)

      relationships = data.fetch('relationships')
      user_data = relationships.fetch('user').fetch('data')
      elements_data = relationships.fetch('elements').fetch('data')

      expect(user_data.fetch('id')).to eq(user.id)
      expect(elements_data.map{|e| e.fetch('id')}.include?(element.id))
        .to eq(true)
    end
  end

  describe '#create' do
    it 'succeeds with existing user email and element' do
      params = {
        title: 'Foo',
        description: 'Bar',
        email: user.email,
        element_ids: element.id
      }

      res = nil

      expect do
        res = post(:create, params: params)
      end.to change(Dream, :count).by(1)

      data = JSON.parse(res.body).fetch('data')

      expect(data.fetch('id').present?).to eq(true)

      attributes = data.fetch('attributes')

      expect(attributes.fetch('title')).to eq('Foo')
      expect(attributes.fetch('description')).to eq('Bar')
      expect(attributes.fetch('show_description')).to eq(false)

      relationships = data.fetch('relationships')
      user_data = relationships.fetch('user').fetch('data')
      elements_data = relationships.fetch('elements').fetch('data')

      expect(user_data.fetch('id')).to eq(user.id)
      expect(elements_data.map{|e| e.fetch('id')}.include?(element.id))
        .to eq(true)
    end

    it 'succeeds with existing user email and multiple element_ids' do
      element2 = Fabricate(:element)

      params = {
        title: 'Foo',
        description: 'Bar',
        email: user.email,
        element_ids: "#{element.id},#{element2.id}"
      }

      res = nil

      expect do
        res = post(:create, params: params)
      end.to change(Dream, :count).by(1)

      data = JSON.parse(res.body).fetch('data')
      relationships = data.fetch('relationships')
      elements_data = relationships.fetch('elements').fetch('data')

      expect(elements_data.map{|e| e.fetch('id')})
        .to match_array([element.id, element2.id])
    end

    it 'succeeds with new user email and element' do
      params = {
        title: 'Foo',
        description: 'Bar',
        email: 'foo@bar.com',
        element_ids: element.id
      }

      res = nil

      expect do
        res = post(:create, params: params)
      end.to change(Dream, :count).by(1)

      body = JSON.parse(res.body)
      data = body.fetch('data')
      included = body.fetch('included')
      users = included.select{|i| i.fetch('type') == 'user'}
      elements = included.select{|i| i.fetch('type') == 'element'}

      expect(data.fetch('id').present?).to eq(true)

      attributes = data.fetch('attributes')

      expect(attributes.fetch('title')).to eq('Foo')
      expect(attributes.fetch('description')).to eq('Bar')
      expect(attributes.fetch('show_description')).to eq(false)

      expect(users.first.fetch('id').present?).to eq(true)
      expect(users.first.fetch('attributes').fetch('email'))
        .to eq('foo@bar.com')

      expect(elements.first.fetch('id')).to eq(element.id)
    end

    it 'fails with missing email' do
      params = {
        title: 'Foo',
        description: 'Bar',
        element_ids: element.id
      }

      res = post(:create, params: params)
      body = JSON.parse(res.body)
      error = body.fetch('error')

      expect(error.include?('ActiveRecord::NotNullViolation')).to eq(true)
      expect(res.code).to eq('500')
    end

    it 'fails with missing title' do
      params = {
        description: 'Bar',
        email: 'foo@bar.com',
        element_ids: element.id
      }

      res = post(:create, params: params)
      body = JSON.parse(res.body)
      error = body.fetch('error')

      expect(error.include?('ActiveRecord::NotNullViolation')).to eq(true)
      expect(res.code).to eq('500')
    end

    it 'fails with missing element_ids' do
      params = {
        title: 'Foo',
        description: 'Bar',
        email: 'foo@bar.com'
      }

      res = post(:create, params: params)
      body = JSON.parse(res.body)

      expect(body.fetch('message')).to eq('Missing at least one symbol ID')
      expect(res.code).to eq('400')
    end

    it 'fails with non-existing element_ids' do
      params = {
        title: 'Foo',
        description: 'Bar',
        email: 'foo@bar.com',
        element_ids: 'Qux'
      }

      res = post(:create, params: params)
      body = JSON.parse(res.body)

      expect(body.fetch('message')).to eq('Missing at least one symbol ID')
      expect(res.code).to eq('400')
    end
  end
end
