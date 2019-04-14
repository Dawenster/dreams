class DreamSerializer
  include FastJsonapi::ObjectSerializer

  set_type :dream

  belongs_to :user
  has_many :elements

  attribute :title
end
