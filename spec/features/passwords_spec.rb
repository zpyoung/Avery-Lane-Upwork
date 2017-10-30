require "rails_helper"

feature "passwords" do
  let!(:user) { FactoryGirl.create(:user) }

  context "sending password reset instructions" do
    scenario "with correct credentials" do
      visit new_user_session_path
      click_link "Forgot your password?"
      expect(page).to have_current_path new_user_password_path
      fill_in "Email", with: user.email
      click_button("Send me reset password instructions")
      expect(page).to have_content("You will receive an email with instructions on how to reset your password in a few minutes.")
      expect(page).to have_current_path new_user_session_path

      expect(ActionMailer::Base.deliveries.count).to eq 1
      email = ActionMailer::Base.deliveries.first
      expect(email.subject).to eq "Reset password instructions"
      expect(email.to).to eq [user.email]
    end

    scenario "with incorrect credentials" do
      visit new_user_session_path
      click_link "Forgot your password?"
      expect(page).to have_current_path new_user_password_path
      fill_in "Email", with: "wrong@email.com"
      click_button("Send me reset password instructions")
      expect(page).to have_content("Please review the problems below:")
      expect(page).to have_content("not found")
    end
  end

  context "clicking on email link" do
    background do
      visit new_user_password_path
      fill_in "Email", with: user.email
      click_button("Send me reset password instructions")
      @reset_password_token, encoded = Devise.token_generator.generate(User, :reset_password_token)
      user.update_column(:reset_password_token, encoded)
      @password = "new_password"
    end

    scenario "with valid token" do
      visit edit_user_password_path(reset_password_token: @reset_password_token)
      fill_in "user_password", with: @password
      fill_in "user_password_confirmation", with: @password
      click_button("Change my password")
      expect(page).to have_current_path root_path
      click_link("Sign Out")
      fill_in "Email", with: user.email
      fill_in "Password", with: @password
      click_button "Log in"
      expect(page).to have_current_path root_path
      expect(page).to have_link("Sign Out")
    end

    scenario "with invalid token" do
      visit edit_user_password_path(reset_password_token: @reset_password_token + "random")
      fill_in "user_password", with: @password
      fill_in "user_password_confirmation", with: @password
      click_button("Change my password")
      expect(page).to have_content("Reset password token is invalid")
      expect(page).to have_current_path user_password_path
    end
  end
end