require 'spec_helper'

describe 'members can finish their account setup' do
  let(:member) { create(:member) }
  let(:other_member) { create(:key_member) }

  before do
    page.set_rack_session(:user_id => member.id)
  end

  it 'allows members to submit information' do
    visit admin_user_setup_path(member)

    fill_in "user_email_for_google", with: "cat@example.com"
    fill_in "user_dues_pledge", with: "25"
    click_button "Submit"

    expect(member.reload.email_for_google).to eq("cat@example.com")
    expect(member.reload.dues_pledge).to eq(25)
  end

  it "does not allow users to edit others' information" do
    visit admin_user_setup_path(other_member)
    fill_in "user_email_for_google", with: "fake@example.com"
    click_button "Submit"

    expect(other_member.reload.email_for_google).not_to eq("fake@example.com")
    expect(member.reload.email_for_google).to eq("fake@example.com")
  end
end