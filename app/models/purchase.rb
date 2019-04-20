# == Schema Information
#
# Table name: purchases
#
#  id           :uuid             not null, primary key
#  message      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  buyer_id     :uuid             not null
#  charge_id    :uuid             not null
#  dream_id     :uuid             not null
#  recipient_id :uuid             not null
#
# Indexes
#
#  index_purchases_on_buyer_id      (buyer_id)
#  index_purchases_on_charge_id     (charge_id)
#  index_purchases_on_dream_id      (dream_id)
#  index_purchases_on_recipient_id  (recipient_id)
#
# Foreign Keys
#
#  fk_rails_...  (buyer_id => users.id)
#  fk_rails_...  (charge_id => charges.id)
#  fk_rails_...  (dream_id => dreams.id)
#  fk_rails_...  (recipient_id => users.id)
#

class Purchase < ActiveRecord::Base
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :dream
  belongs_to :charge
end
