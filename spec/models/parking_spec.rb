require 'rails_helper'

RSpec.describe Parking, type: :model do
  describe ".validate_end_at_with_amount" do
    
    it "is invalid without end_at" do
      parking = Parking.new( :parking_type => "guest",
                             :start_at => Time.now - 6.hours,
                             :amount => 999)
      expect( parking ).to_not be_valid
    end
  
  end

  describe "setup amount" do
    before do
      @time = Time.new(2017,9,1,8,0,0)   # 创建一个时间对象即可
    end
    
    context "guest" do

      before do
        @parking = Parking.new( :parking_type => "guest", :start_at => @time, :user => @user )
      end

      it "30 mins should be ¥2" do
        @parking.end_at = @time + 30.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end

      it "60 mins should be ¥2" do
        @parking.end_at = @time + 60.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end

      it "61 mins should be ¥3" do
        @parking.end_at = @time + 61.minutes
        @parking.save
        expect(@parking.amount).to eq(300)
      end

      it "90 mins should be ¥3" do
        @parking.end_at = @time + 90.minutes
        @parking.save
        expect(@parking.amount).to eq(300)
      end

      it "120 mins should be ¥4" do
        @parking.end_at = @time + 120.minutes
        @parking.save
        expect(@parking.amount).to eq(400)
      end
    end

    context "short-term" do

      before do
        @user = User.create(:email => "test@example.com", password: "12345678")
        @parking = Parking.new( :parking_type => "short-term",
                                :start_at => @time, :user => @user )
      end
      
      it "30 mins should be ¥2" do
        @parking.end_at = @time + 30.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end

      it "60 mins should be ¥2" do
        @parking.end_at = @time + 60.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end

      it "61 mins should be ¥2.5" do
        @parking.end_at = @time + 61.minutes
        @parking.save
        expect(@parking.amount).to eq(250)
      end
      
      it "90 mins should be ¥2.5" do
        @parking.end_at = @time + 90.minutes
        @parking.save
        expect(@parking.amount).to eq(250)
      end

      it "120 mins should be ¥3" do
        @parking.end_at = @time + 120.minutes
        @parking.save
        expect(@parking.amount).to eq(300)
      end
    end

    context "long-term" do

      before do
        @user = User.create(:email => "test@example.com", password: "12345678")
        @parking = Parking.new( :parking_type => "long-term",
                                :start_at => @time, :user => @user )
      end

      it "300 mins should be ¥12" do
        @parking.end_at = @time + 300.minutes
        @parking.save
        expect(@parking.amount).to eq(1200)
      end

      it "360 mins should be ¥12" do
        @parking.end_at = @time + 360.minutes
        @parking.save
        expect(@parking.amount).to eq(1200)
      end

      it "720 mins should be ¥16" do
        @parking.end_at = @time + 720.minutes
        @parking.save
        expect(@parking.amount).to eq(1600)
      end

      it "1440 mins should be ¥16" do
        @parking.end_at = @time + 1440.minutes
        @parking.save
        expect(@parking.amount).to eq(1600)
      end

      it "1800 mins should be ¥28" do     # 超过一天，但没有超过6个小时内
        @parking.end_at = @time + 1800.minutes
        @parking.save
        expect(@parking.amount).to eq(2800)
      end 

       it "2000 mins should be ¥32" do    # 超过一天且超过了6个小时
        @parking.end_at = @time + 2000.minutes
        @parking.save
        expect(@parking.amount).to eq(3200)
      end 
    end
  
  end

end
