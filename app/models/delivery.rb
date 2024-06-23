# == Schema Information
#
# Table name: deliveries
#
#  id                    :integer          not null, primary key
#  arrived               :boolean
#  description           :text
#  details               :text
#  supposed_to_arrive_on :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :integer
#
class Delivery < ApplicationRecord
  validates(:supposed_to_arrive_on, presence: true) #make sure the arrival date is set
  validates(:description, presence: true) #make sure description is set
  validates(:details, presence: true) #make sure details is set

  belongs_to(:user)
end
