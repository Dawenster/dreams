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
#  payment_method_type      :string           not null
#  status                   :string           not null
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

Fabricator(:payment_method) do
  brand 'visa'
  exp_month '01'
  exp_year '2099'
  funding 'credit'
  last4 '4242'
  status 'succeeded'
  payment_method_type 'card'
end
