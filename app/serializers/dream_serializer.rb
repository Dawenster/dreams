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

class DreamSerializer
  include FastJsonapi::ObjectSerializer

  set_type :dream

  belongs_to :user
  has_many :elements, serializer: ElementSerializer

  attributes :redacted_description, :published
end
