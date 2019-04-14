class DreamSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :user
  has_many :elements

  attributes :title
end
