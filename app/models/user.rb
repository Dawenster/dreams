# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  email      :string           not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  has_many :dreams, dependent: :destroy
  has_many :charges
  has_many :payment_methods
  has_many :purchases,
           foreign_key: 'buyer_id',
           class_name: 'Purchase'
  has_many :purchases_received,
           foreign_key: 'recipient_id',
           class_name: 'Purchase'
end
