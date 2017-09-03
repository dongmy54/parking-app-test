require 'rails_helper'

feature "parking", :type => :feature do

  scenario "long_term" do
    user = User.create( :email => "test@example.com",
                        :password => "12345678" )

    sign_in(user)

    visit "/"              # 不要忘了。还要拜访首页

    choose "长期费率"       #  选择长期费率

    click_button "开始计费"

    click_button "结束计费"

    expect(page).to have_content("¥12.00")
  end

end