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
    click_link('Edit or Delete')
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
    click_link('Edit or Delete')
    fill_in('title', with: "Harry Potter and the Deathly Hallows")
    click_button('Update Book')
    expect(page).to have_content("Harry Potter and the Deathly Hallows")
  end

  it 'allows admin to delete a patron' do
    visit('/')
    visit('/login')
    fill_in('username', with: "librarian")
    fill_in('password', with: "library")
    click_button('Log In')
    click_link('Patrons')
    click_link('Add a Patron')
    fill_in('first-name', :with => "Frank")
    fill_in('last-name', :with => "Herbert")
    click_button('Add Patron')
    click_link('Frank Herbert')
    click_link('Edit or Delete')
    click_link('Delete')
    click_button('Delete')
    expect(page).to have_no_content("Frank Herbert")
  end

  it 'allows admin to delete a book' do
    visit('/')
    visit('/login')
    fill_in('username', with: "librarian")
    fill_in('password', with: "library")
    click_button('Log In')
    click_link('Catalog')
    click_link('Add a Book')
    fill_in('title', :with => "Fantastic Beasts")
    fill_in('author-first', :with => "J. K.")
    fill_in('author-last', :with => "Rowling")
    click_button('Add Book')
    click_link("Fantastic Beasts")
    click_link('Edit or Delete')
    click_link('Delete')
    click_button('Delete')
    expect(page).to have_no_content("Fantastic Beasts")
  end
end

describe('Patron Portal', {:type =>:feature}) do
  it 'allows patron to checkout a book and check a book in' do
    visit('/')
    click_link('Log In')
    fill_in('username', with: "bob")
    fill_in('password', with: "1234")
    click_button('Log In')
    click_link('Catalog')
    first('.book').click_link('Harry Potter')
    click_button('Check Out')
    expect(page).to have_content("Checked Out")
    click_button('Check In')
    expect(page).to have_content("Checked In")
  end
end
