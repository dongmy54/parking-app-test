class Parking < ApplicationRecord

  validates_presence_of :parking_type, :start_at
  validates_inclusion_of :parking_type, :in => ["guest", "short-term", "long-term"]

  validate :validate_end_at_with_amount

  before_validation :setup_amount
  
  belongs_to :user, :optional => true
  
  def validate_end_at_with_amount
    if ( end_at.blank? && amount.present? )
      errors.add(:end_at, "有金额就必须有结束时间")
    end
  end

  def duration
    ( end_at - start_at ) / 60
  end
  
  def setup_amount
     factor = (self.user.present?)? 50 : 100

    if self.amount.blank? && self.start_at.present? && self.end_at.present?
      if self.user.blank?
        self.amount = calculate_guest_term_amount   # 一般费率
      elsif self.parking_type == "short-term"
        self.amount = calculate_short_term_amount   # 短期费率
      elsif self.parking_type == "long-term"
        self.amount = calculate_long_term_amount    # 长期费率
      end 
    end
  end

  def calculate_guest_term_amount
    if duration <= 60
      self.amount = 200
    else
      self.amount = 200 + ((duration - 60).to_f / 30).ceil * 100
    end
  end

  def calculate_short_term_amount
    if duration <= 60
      self.amount = 200
    else
      self.amount = 200 + ((duration - 60).to_f / 30).ceil * 50
    end
  end

  def calculate_long_term_amount
    if duration <= 1440
      within_one_day_amount(duration)
    else
      day = (duration / 1440).to_i
      rest_time = (duration - 1440 * day)
      self.amount = (day * 1600) + (within_one_day_amount(rest_time)) 
    end
  end

  def within_one_day_amount(time)     # 停车时间在一天内计算方式
    if time <= 360
      self.amount = 1200
    else 
      self.amount = 1600
    end
  end

end
