require "rails_helper"

feature "users" do
  context "as guest" do
    scenario "viewing list" do
      visit users_path
      expect(page).to have_current_path new_user_session_path
    end
  end

  context "as admin", js: true  do
    let!(:user) { FactoryGirl.create(:user, role: User::Role::ADMIN) }
    let!(:user2) { FactoryGirl.create(:user, email: "snow@example.com", first_name: "Jack", last_name: "Snow") }

    background do
      login_as user
    end

    scenario "viewing list"do
      visit root_path
      click_link "Admin"
      click_link "Users"
      within "table.table tbody" do
        expect(page).to have_content(user.to_s)
        expect(page).to have_content(user.email)
        expect(page).to have_content(user2.to_s)
        expect(page).to have_content(user2.email)
      end
      expect(page).to have_current_path users_path
    end
    
    context "search" do
      scenario "search by name" do
        visit users_path
        fill_in "Search by name…", with: "Jack Sno"
        within "table.table tbody" do
          expect(page).to have_no_content(user.to_s)
          expect(page).to have_no_content(user.email)
          expect(page).to have_content(user2.to_s)
          expect(page).to have_content(user2.email)
        end
      end
      
      scenario "sort by name" do
        visit users_path
        within "table.table tbody tr:last-child" do
          expect(page).to have_content(user.to_s)
        end
        within "table.table tbody tr:first-child" do
          expect(page).to have_content(user2.to_s)
        end
        click_link "Name"
        within "table.table tbody tr:last-child" do
          expect(page).to have_content(user2.to_s)
        end
        within "table.table tbody tr:first-child" do
          expect(page).to have_content(user.to_s)
        end
        
        expect(page).to have_current_path users_path
      end
      
      scenario "paginate" do
        FactoryGirl.create_list(:user, 25)
        visit users_path
        expect(page).to have_css("table.table tbody tr", count: 25)
        within ".pagination" do
          click_link(2)
        end
        expect(page).to have_css("table.table tbody tr", count: 2)
      end
    end

    scenario "creating successfully with invitation", js: true do
      FactoryGirl.create(:user, first_name: "Jim", last_name: "Manager")
      visit users_path
      click_link "Add User"
      expect(page).to have_css("#ajax-modal", visible: true)
      within("#ajax-modal") do
        expect(page).to have_content("Add User")
        fill_in "First Name", with: "Jack"
        fill_in "Last Name", with: "Doeman"
        fill_in "Phone", with: "8888888"
        fill_in "Email", with: "doeman@example.com"
        select "(GMT-08:00) Pacific Time (US & Canada)", from: "Time Zone"
        check "Support"
        click_button("Invite User")
      end
      expect(page).to have_css("#ajax-modal", visible: false)
      expect(page).to have_current_path users_path
      within "table.table tbody tr:first-child" do
        expect(page).to have_content("Jack Doeman")
        expect(page).to have_content("doeman@example.com")
        expect(page).to have_content("Pending Invitation")
        expect(page).to have_content("8888888")
        expect(page).to have_css("span.label", text: "Support")
      end
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(ActionMailer::Base.deliveries.last.subject).to eq "Invitation instructions"
      expect(ActionMailer::Base.deliveries.last.to).to eq ["doeman@example.com"]
    end

    scenario "creating unsuccessfully", js: true do
      visit users_path
      click_link "Add User"
      expect(page).to have_css("#ajax-modal", visible: true)
      within("#ajax-modal") do
        expect(page).to have_content("Add User")
        click_button "Invite User"
      end
      within "form#new_user" do
        expect(page).to have_content("Please review the problems below:")
        expect(page).to have_content("can't be blank")
      end
    end

    scenario "updating successfully", js: true do
      visit users_path
      within("table tbody tr:first-child") do
        find_link("Edit").trigger("click")
      end
      expect(page).to have_css("#ajax-modal", visible: true)
      within("#ajax-modal") do
        fill_in "First Name", with: "ChangedFirstName"
        fill_in "Last Name", with: "ChangedLastName"
        fill_in "Email", with: "change@example.com"
        fill_in "Phone", with: "444444"
        click_button "Save"
      end
      expect(page).to have_css("#ajax-modal", visible: false)
      expect(page).to have_current_path users_path
      expect(page).to have_content("ChangedFirstName ChangedLastName")
      expect(page).to have_content("change@example.com")
    end

    scenario "updating unsuccessfully", js: true do
      visit users_path
      within("table tbody tr:first-child") do
        find_link("Edit").trigger("click")
      end
      expect(page).to have_css("#ajax-modal", visible: true)
      within("#ajax-modal") do
        fill_in "First Name", with: ""
        click_button "Save"
      end
      within("#ajax-modal") do
        expect(page).to have_content("Please review the problems below:")
        expect(page).to have_content("can't be blank")
      end
    end

    scenario "archiving", js: true do
      FactoryGirl.create(:user, first_name: "Wyatt", last_name: "Doeman")
      visit users_path
      within("table tbody tr:last-child") do
        click_link "Archive"
      end
      expect(page).to have_css("#confirm-modal", visible: true)
      within("#confirm-modal") do
        click_link "Confirm"
      end
      expect(page).to have_css("span.label", text: "Archived")
    end

    scenario "resending invite", js: true do
      User.invite!(first_name: "John", last_name: "Doe", email: "john@doe.com")
      visit users_path
      click_link "Resend Invite"
      within("#confirm-modal") do
        click_link "Confirm"
      end
      expect(page).to have_current_path users_path
      expect(ActionMailer::Base.deliveries.size).to eq 2
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to eq "Invitation instructions"
      expect(email.to).to eq ["john@doe.com"]
    end
  end
end