require "rails_helper"

feature "invitations", js: true do
  let!(:user) { user = User.new(email: "user@example.com", role: User::Role::ADMIN); user.save!(validate: false); user }

  context "click on email link" do
    background do
      @invitation_token, encoded = Devise.token_generator.generate(User, :invitation_token)
      user.update_column(:invitation_token, encoded)
      user.update_column(:invitation_sent_at, Time.now)
      user.update_column(:invitation_created_at, Time.now)
    end

    scenario "with valid token" do
      visit accept_user_invitation_path(invitation_token: @invitation_token)
      fill_in "First Name", with: "Tom"
      fill_in "Last Name", with: "Cruise"
      fill_in "Phone", with: "12345"
      fill_in "user_password", with: "newpassword"
      fill_in "Confirm Your Password", with: "newpassword"
      click_button "Set My Password"
      expect(page).to have_content("Dashboard")
      expect(page).to have_current_path root_path
      expect{ user.reload }.to change { user.invitation_accepted_at }
      expect(user.first_name).to eq "Tom"
      expect(user.last_name).to eq "Cruise"
      expect(user.phone).to eq "12345"
    end

    scenario "with invalid token" do
      visit accept_user_invitation_path(invitation_token: @invitation_token + "random")
      expect(page).to have_content("The invitation token provided is not valid!")
      expect(page).to have_current_path new_user_session_path
    end
  end
end