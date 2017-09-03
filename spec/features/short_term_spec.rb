require 'rails_helper'

feature "parking", :type => :feature do

  scenario "short_term" do
    user = User.create( :email => "test@example.com",
                        :password => "12345678" )
    sign_in(user)      # 这样登录

    visit "/"
    choose "短期费率"   # 选 radio button

    click_button "开始计费"

    click_button "结束计费"

    expect(page).to have_content("¥2.00")
  end

  
end