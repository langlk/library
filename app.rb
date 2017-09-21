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

book = Book.new({
  title: "Harry Potter",
  author_first: "J. K.",
  author_last: "Rowling"
})
book.save

patron = Patron.new({
  first_name: "Bob",
  last_name: "Bobbington",
})
patron.save

user = User.new({
  username: "bob",
  password: "1234",
  patron_id: patron.id,
  email: "bob@email.com"
})
user.save

# ROUTES
before do
  @user = session[:id] != nil ? User.find_id(session[:id]) : nil
end

get('/') do
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
    patron_id: params["patron-id"].to_i,
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
  @books = Book.all
  erb(:catalog)
end

get('/catalog/:id') do
  @book = Book.find(params[:id].to_i).first
  erb(:book)
end

patch('/catalog/:book_id/checkout') do
  if @user
    book_id = params[:book_id].to_i
    book = Book.find(book_id).first
    binding.pry
    book.checkout(@user.patron_id)
  end
  redirect "/catalog/#{book_id}"
end

patch('/catalog/:book_id/checkin') do
  if @user
    book_id = params[:book_id].to_i
    book = Book.find(book_id).first
    book.checkin
  end
  redirect "catalog/#{book_id}"
end

get('/add-book') do
  @action = "add"
  erb(:book_form)
end

post('/add-book') do
  book = Book.new({
    title: params["title"],
    author_first: params["author-first"],
    author_last: params["author-last"]
  })
  book.save
  redirect "/catalog"
end

get('/catalog/:book_id/edit') do
  @book = Book.find(params[:book_id].to_i).first
  @action = "edit"
  erb(:book_form)
end

patch('/catalog/:book_id/edit') do
  @book = Book.find(params[:book_id].to_i).first
  if @book
    @book.title = params["title"]
    @book.author_first = params["author-first"]
    @book.author_last = params["author-last"]
    @book.save
  end
  redirect "/catalog/#{@book.id}"
end

get('/patrons') do
  @patrons = Patron.all
  erb(:patrons)
end

get('/add-patron') do
  @action = "add"
  erb(:patron_form)
end

post('/add-patron') do
  patron = Patron.new({
    first_name: params["first-name"],
    last_name: params["last-name"]
  })
  patron.save
  redirect "/patrons"
end

get('/patrons/:id') do
  id = params[:id].to_i
  @patron = Patron.find(id).first
  erb(:patron)
end

get('/patrons/:id/edit') do
  patron_id = params[:id].to_i
  @patron = Patron.find(patron_id).first
  @action = "edit"
  erb(:patron_form)
end

get('/account/:type') do
  @type = params[:type]
  @patron = Patron.find(@user.patron_id).first
  @checkouts = @patron.get_checkouts
  erb(:checkouts)
end

get('/account') do
  @patron = @user.admin ? nil : Patron.find(@user.patron_id).first
  erb(:account)
end
#REFACTOR ZONE

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
