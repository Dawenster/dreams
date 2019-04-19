# == Schema Information
#
# Table name: payment_methods
#
#  id                       :uuid             not null, primary key
#  brand                    :string           not null
#  exp_month                :string           not null
#  exp_year                 :string           not null
#  funding                  :string           not null
#  last4                    :string           not null
#  status                   :string           not null
#  type                     :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  stripe_payment_method_id :string           not null
#  user_id                  :uuid             not null
#
# Indexes
#
#  index_payment_methods_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class PaymentMethod < ActiveRecord::Base
  has_many :charges
  belongs_to :user
end
