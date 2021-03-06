require 'spec_helper'
feature "Dragonfly integration", js: true do
  background do
    auth_as_user
  end

  scenario "Upload, view and remove image" do
    visit new_admin_book_path
    fill_in "Title", with: "xx"
    attach_file "Cover image", File.expand_path('../fixtures/cs.png', __dir__)
    click_button "Save"
    expect(page).to have_notification("Create succeeded")

    find(".field[data-name='cover_image_uid'] a.ajaxbox" ).click
    expect(page).to have_css(".fancybox-inner img.fancybox-image")
    find(".fancybox-inner button.close" ).click
    expect(page).to have_no_css(".fancybox-inner img.fancybox-image")

    check "Remove image"
    click_button "Save"
    expect(page).to have_notification("Update succeeded")
    expect(page).to have_no_css(".field[data-name='cover_image_uid'] a.ajaxbox")
  end
end
