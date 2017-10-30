require "rails_helper"

feature "sessions", js: true do
  let(:user) { FactoryGirl.create(:user, password: "password") }

  context "as guest" do
    scenario "viewing dashboard redirects to sign in" do
      visit root_path
      expect(page).to have_current_path new_user_session_path
    end

    scenario "signing in with correct credentials" do
      visit root_path
      expect(page).to have_current_path new_user_session_path
      expect(page).to have_css(".alert.alert-danger")
      expect(page).to have_content("You need to sign in before continuing.")
      fill_in "Email", with: user.email
      fill_in "Password", with: "password"
      click_button "Log in"
      expect(page).to have_link("Sign Out")
    end

    scenario "signing in with incorrect credentials" do
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: ""
      click_button "Log in"
      expect(page).to have_current_path new_user_session_path
      expect(page).to have_css(".alert.alert-danger")
      expect(page).to have_content("Invalid email or password.")
      expect(page).to have_no_link("Sign Out")
    end
    
    scenario "signing in with archived account" do
      user.update_column(:deleted_at, Time.zone.now)
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "password"
      click_button "Log in"
      expect(page).to have_current_path new_user_session_path
      expect(page).to have_css(".alert.alert-danger")
      expect(page).to have_content("Your account has been archived.")
      expect(page).to have_no_link("Sign Out")
    end
  end

  context "as user", js: true do
    background do
      login_as user
    end

    scenario "viewing dashboard" do
      visit root_path
      expect(page).to have_current_path root_path
    end

    scenario "signing in when already signed in" do
      visit new_user_session_path
      expect(page).to have_current_path root_path
      expect(page).to have_content("Dashboard")
    end

    scenario "sign out" do
      visit root_path
      click_link "Sign Out"
      expect(page).to have_no_link("Sign Out")
      expect(page).to have_current_path new_user_session_path
    end
  end
end