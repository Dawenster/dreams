class ElementSerializer
  include FastJsonapi::ObjectSerializer

  set_type :element

  attributes :name, :dimension, :commentary, :image_url
end
