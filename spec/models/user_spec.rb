require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user) { FactoryGirl.create(:user ) }

  describe "validations" do
    describe "email" do
      it "is required" do
        user = FactoryGirl.build(:user, email: nil)
        user.save
        expect(user.errors[:email]).to be_present
      end
    end

    describe "first_name" do
      it "is required" do
        user = FactoryGirl.build(:user, first_name: nil)
        user.save
        expect(user.errors[:first_name]).to be_present
      end
    end

    describe "last_name" do
      it "is required" do
        user = FactoryGirl.build(:user, last_name: nil)
        user.save
        expect(user.errors[:last_name]).to be_present
      end
    end
  end

  describe "#to_s" do
    it "returns full name" do
      expect(user.to_s).to eq("John Doe")
    end
  end

  describe "#soft_delete" do
    it "updates deleted_at" do
      expect{ user.soft_delete }.to change { user.deleted_at }.from(nil)
    end
  end

  describe "#active_for_authentication?" do
    it "returns true if not deleted" do
      user.deleted_at = nil
      expect(user.active_for_authentication?).to eq true
    end

    it "returns false if not deleted" do
      user.deleted_at = Time.now
      expect(user.active_for_authentication?).to eq false
    end
  end
end