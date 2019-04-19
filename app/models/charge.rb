# == Schema Information
#
# Table name: charges
#
#  id                :uuid             not null, primary key
#  amount_in_cents   :integer          not null
#  currency          :string           not null
#  fees_in_cents     :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  payment_method_id :uuid             not null
#  stripe_charge_id  :string           not null
#  user_id           :uuid             not null
#
# Indexes
#
#  index_charges_on_payment_method_id  (payment_method_id)
#  index_charges_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (payment_method_id => payment_methods.id)
#  fk_rails_...  (user_id => users.id)
#

class Charge < ActiveRecord::Base
  belongs_to :user
  belongs_to :payment_method
end
