require "rails_helper"

feature "sessions", js: true do
  let(:user) { FactoryGirl.create(:user, password: "password", first_name: "John", last_name: "Doe") }

  context "as user", js: true do
    background do
      login_as user
    end

    scenario "updating profile successfully with avatar" do
      visit root_path
      expect(page).to have_no_css(".nav.navbar-right img.thumb32")
      click_link "John Doe"
      expect(page).to have_css("#ajax-modal", visible: true)
      within("#ajax-modal") do
        expect(page).to have_content("Edit Profile")
        fill_in "First Name", with: "Jack"
        fill_in "Last Name", with: "Doeman"
        fill_in "Email", with: "changed@example.com"
        fill_in "Current Password", with: "password"
        click_button("Save")
      end
      expect(page).to have_no_css("#ajax-modal", visible: true)
      expect{ user.reload }.to change { user.first_name }.to("Jack")
      expect(page).to have_current_path root_path
    end
    
    scenario "updating password successfully" do
      visit root_path
      click_link "John Doe"
      within("#ajax-modal") do
        expect(page).to have_content("Edit Profile")
        fill_in "Current Password", with: "password"
        click_link "Change Password"
        fill_in "New Password", with: "newpassword"
        fill_in "New Password Confirmation", with: "newpassword"
        click_button("Save")
      end
      expect(page).to have_no_css("#ajax-modal", visible: true)
      expect{user.reload}.to change{user.encrypted_password}
      expect(page).to have_current_path root_path
    end
    
    scenario "updating password unsuccessfully" do
      visit root_path
      click_link "John Doe"
      within("#ajax-modal") do
        expect(page).to have_content("Edit Profile")
        fill_in "Current Password", with: "password"
        click_link "Change Password"
        fill_in "New Password", with: "newpassword"
        fill_in "New Password Confirmation", with: "newwrongpassword"
        click_button("Save")
        expect(page).to have_content("doesn't match")
      end
    end

    scenario "updating profile unsuccessfully without password" do
      visit root_path
      click_link "John Doe"
      expect(page).to have_css("#ajax-modal", visible: true)
      within("#ajax-modal") do
        expect(page).to have_content("Edit Profile")
        fill_in "First Name", with: "Jack"
        fill_in "Last Name", with: "Doeman"
        fill_in "Email", with: "changed@example.com"
        click_button("Save")
        expect(page).to have_content("can't be blank")
      end
      expect{ user.reload }.to_not change { user.first_name }
    end
  end
end