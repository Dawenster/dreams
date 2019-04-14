require 'rails_helper'

RSpec.describe ElementsController, type: :controller do
  let!(:e1) { Fabricate(:element) }
  let!(:e2) { Fabricate(:element) }
  let!(:e3) { Fabricate(:element) }

  describe '#index' do
    it 'returns all elements' do
      res = get(:index)
      data = JSON.parse(res.body).fetch('data')

      expect(data.map{|d| d.fetch('id')}).to match_array([e1.id, e2.id, e3.id])
    end
  end
end
