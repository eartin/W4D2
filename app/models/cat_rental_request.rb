# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :bigint           not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CatRentalRequest < ApplicationRecord
  validates :status, inclusion: { in: ['APPROVED', 'DENIED','PENDING'] }
  validates :cat_id, :start_date, :end_date, presence: true
  validate :does_not_overlap_approved_request

  belongs_to :cat, 
    foreign_key: :cat_id,
    class_name: :Cat 


  def overlapping_requests
    overlapping_requests = []
    old_requests = CatRentalRequest.find_by(cat_id: :cat_id)
    unless old_requests.nil?
    old_requests.each do |request|
      if request.start_date >= start_date and request.end_date <= end_date and status == 'APPROVED'
        overlapping_requests << request 
      end
    end
    end
    overlapping_requests
  end

  def does_not_overlap_approved_request
    CatRentalRequest.exists?(overlapping_requests)
  end
end
