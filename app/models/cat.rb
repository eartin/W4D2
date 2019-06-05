# == Schema Information
#
# Table name: cats
#
#  id          :bigint           not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cat < ApplicationRecord
  COLORS = %w(black gray white red blue green yellow orange brown purple pink)
  include ActionView::Helpers::DateHelper
  validates :color, inclusion: { in: COLORS }
  validates :sex, inclusion: {in: ['M', 'F']}
  validates :birth_date, :color, :name, :sex, :description, presence: true
  def age
    ((Time.zone.now - birth_date.to_time) / 1.year.seconds).floor
  end

  has_many :rental_requests,
    foreign_key: :cat_id,
    class_name: :CatRentalRequest,
    dependent: :destroy
    
end
