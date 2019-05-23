# == Schema Information
#
# Table name: dreams
#
#  id          :uuid             not null, primary key
#  description :text             not null
#  published   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_dreams_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Dream < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :elements
  has_many :purchases

  scope :published, -> { where(published: true) }

  def redacted_description
    description.split(' ').each_with_index.map do |word, i|
      redactable?(word) || i % 5 === 4 ? redact!(word) : word
    end.join(' ')
  end

  private

  def redactable?(string)
    string.length >= 6
  end

  def redact!(string)
    '*' * string.length
  end
end
