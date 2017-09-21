require 'capybara/rspec'
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('Administrator access', {:type => :feature}) do
  it 'allows admin to add new books' do
    visit('/')
    visit('/login')
    fill_in('username', with: "librarian")
    fill_in('password', with: "library")
    click_button('Log In')
    click_link('Catalog')
    click_link('Add a Book')
    fill_in('title', :with => "Harry Potter and the Goblet of Fire")
    fill_in('author-first', :with => "J. K.")
    fill_in('author-last', :with => "Rowling")
    click_button('Add Book')
    expect(page).to have_content("Harry Potter and the Goblet of Fire")
  end

  it "allows admin to add new patrons" do
    visit('/')
    visit('/login')
    fill_in('username', with: "librarian")
    fill_in('password', with: "library")
    click_button('Log In')
    click_link('Patrons')
    click_link('Add a Patron')
    fill_in('first-name', :with => "Bob")
    fill_in('last-name', :with => "Smith")
    click_button('Add Patron')
    expect(page).to have_content("Bob Smith")
  end

  it 'allows admin to edit a patron' do
    visit('/')
    visit('/login')
    fill_in('username', with: "librarian")
    fill_in('password', with: "library")
    click_button('Log In')
    click_link('Patrons')
    click_link('Add a Patron')
    fill_in('first-name', :with => "Bob")
    fill_in('last-name', :with => "Smith")
    click_button('Add Patron')
    click_link('Bob Smith')
    click_link('Edit')
    fill_in('first-name', :with => "James")
    fill_in('last-name', :with => "Jenkins")
    click_button('Update Patron')
    expect(page).to have_content("James Jenkins")
  end

  it 'allows admin to edit a book' do
    visit('/')
    visit('/login')
    fill_in('username', with: "librarian")
    fill_in('password', with: "library")
    click_button('Log In')
    click_link('Catalog')
    click_link('Add a Book')
    fill_in('title', :with => "Harry Potter and the Goblet of Fire")
    fill_in('author-first', :with => "J. K.")
    fill_in('author-last', :with => "Rowling")
    click_button('Add Book')
    click_link('Harry Potter and the Goblet of Fire')
    click_link('Edit')
    fill_in('title', with: "Harry Potter and the Deathly Hallows")
    click_button('Update Book')
    expect(page).to have_content("Harry Potter and the Deathly Hallows")
  end
end
#
#   it 'allows admin to delete a book' do
#     visit('/admin')
#     click_link('Books')
#     click_link('Add a Book')
#     fill_in('title', :with => "Harry Potter")
#     fill_in('author-first', :with => "J. K.")
#     fill_in('author-last', :with => "Rowling")
#     click_button('Add Book')
#     click_link('Harry Potter')
#     click_button('Delete')
#     expect(page).to have_no_content("Harry Potter")
#   end
# end
#
# describe('Patron Portal', {:type =>:feature}) do
#   it 'allows patron to checkout a book and check a book in' do
#     visit('/patron')
#     click_button('Sign In')
#     click_link('Catalog')
#     click_link('Harry Potter')
#     click_button('Check Out')
#     expect(page).to have_content("Checked Out")
#     click_button('Check In')
#     expect(page).to have_content("Checked In")
#   end
# end
