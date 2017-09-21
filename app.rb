require "sinatra"
require "sinatra/reloader"
also_reload "lib/**/*.rb"
require "pg"
require "./lib/book"
require "./lib/patron"
require "./lib/checkout"
require "./lib/user"
require "pry"

# SETUP

DB = PG.connect({:dbname => 'library_test'})
enable :sessions

admin = User.new({
  patron_id: -1,
  email: "admin@library.com",
  username: "librarian",
  password: "library",
  admin: true
})
admin.save

# ROUTES

get('/') do
  @user = session[:id] != nil ? User.find_id(session[:id]) : nil
  erb(:index)
end

get('/login') do
  erb(:login)
end

get('/signup') do
  erb(:signup)
end

post('/login') do
  user = User.find_user(params["username"])
  if user
    if user.check_password?(params["password"])
      session[:id] = user.id
      redirect "/"
    end
  end
  @error = true
  erb(:login)
end

post('/signup') do
  user = User.new({
    patron_id: params["patron_id"].to_i,
    username: params["username"],
    email: params["email"],
    password: params["password"]
  })
  user.save
  session[:id] = user.id
  redirect "/"
end

post('/logout') do
  session.clear
  redirect '/'
end

get('/catalog') do
  @user = session[:id] != nil ? User.find_id(session[:id]) : nil
  @books = Book.all
  erb(:catalog)
end

get('/catalog/:id') do
  @user = session[:id] != nil ? User.find_id(session[:id]) : nil
  @book = Book.find(params[:id].to_i).first
  erb(:book)
end

patch('/catalog/:book_id/checkout') do
  @user = session[:id] != nil ? User.find_id(session[:id]) : nil
  if @user
    book_id = params[:book_id].to_i
    book = Book.find(book_id).first
    book.checkout(@user.patron_id)
  end
  redirect "/catalog/#{book_id}"
end

get('/catalog/add') do
  @user = session[:id] != nil ? User.find_id(session[:id]) : nil
  @action = "add"
  erb(:book_form)
end

post('/catalog/add') do
  book = Book.new({
    title: params["title"],
    author_first: params["author-first"],
    author_last: params["author-last"]
  })
  book.save
  redirect "/catalog"
end

# Refactoring line
get('/patrons') do
  @user = session[:id] != nil ? User.find_id(session[:id]) : nil
  @patrons = Patron.all
  erb(:patrons)
end

get('/patrons/add') do
  erb(:add_patron)
end



post('/patron/add') do
  patron = Patron.new({
    first_name: params["first-name"],
    last_name: params["last-name"]
  })
  patron.save
  redirect "/admin/patrons"
end

post('/patron') do
  @patron = Patron.find(params['patron-id'].to_i).first
  redirect "/patron/patrons/#{@patron.id}"
end



get('/:user/patrons/:id') do
  id = params[:id].to_i
  @user = params[:user]
  @patron = Patron.find(id).first
  erb(:patron)
end

patch('/:patron_id/:book_id/checkout') do
  patron_id = params[:patron_id].to_i
  book_id = params[:book_id].to_i
  book = Book.find(book_id).first
  book.checkout(patron_id)
  redirect "#{patron_id}/books/#{book_id}"
end

patch('/:patron_id/:book_id/checkin') do
  patron_id = params[:patron_id].to_i
  book_id = params[:book_id].to_i
  book = Book.find(book_id).first
  book.checkin
  redirect "#{patron_id}/books/#{book_id}"
end

get('/admin/patrons/:id/edit') do
  id = params[:id].to_i
  @patron = Patron.find(id).first
  erb(:edit_patron)
end

patch('/patrons/:id') do
  id = params[:id].to_i
  patron = Patron.find(id).first
  patron.first_name = params['first-name']
  patron.last_name = params['last-name']
  patron.save
  redirect "/admin/patrons/#{patron.id}"
end

delete('/admin/patrons/:id') do
  id = params[:id].to_i
  patron = Patron.find(id).first
  patron.delete
  redirect "/admin/patrons"
end

delete('/admin/books/:id') do
  id = params[:id].to_i
  book = Book.find(id).first
  book.delete
  redirect "/admin/books"
end
