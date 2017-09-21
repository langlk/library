#!/usr/bin/env ruby

class User
  attr_reader :id, :username, :admin, :patron_id
  attr_writer :password
  attr_accessor :email

  def initialize(attributes)
    @id = attributes.fetch(:id) { nil }
    @patron_id = attributes[:patron_id]
    @email = attributes[:email]
    @username = attributes[:username]
    @password = attributes[:password]
    @admin = attributes.fetch(:admin) { false }
  end

  def check_password?(input)
    @password == input
  end

  def save
    if @id
      DB.exec("UPDATE users SET patron_id = #{@patron_id}, email = '#{@email}', username = '#{@username}', password = '#{@password}', admin = #{@admin} WHERE id = #{@id};")
    else
      results = DB.exec("INSERT INTO users (patron_id, email, username, password, admin) VALUES (#{@patron_id}, '#{@email}', '#{@username}', '#{@password}', #{@admin}) RETURNING id;")
      @id = results.first["id"].to_i
    end
  end

  def make_admin
    @admin = true
  end

  def self.all
    results = DB.exec("SELECT * FROM users;")
    results.map do |user|
      User.new({
        id: user["id"].to_i,
        patron_id: user["patron_id"].to_i,
        email: user["email"],
        username: user["username"],
        password: user["password"],
        admin: user["admin"] == "t"
      })
    end
  end

  def self.find_id(id)
    results = DB.exec("SELECT * FROM users WHERE id = #{id};")
    User.new({
      id: results.first["id"].to_i,
      patron_id: results.first["patron_id"].to_i,
      email: results.first["email"],
      username: results.first["username"],
      password: results.first["password"],
      admin: results.first["admin"] == "t"
    })
  end

  def self.find_user(username)
    results = DB.exec("SELECT * FROM users WHERE username = '#{username}';")
    User.new({
      id: results.first["id"].to_i,
      patron_id: results.first["patron_id"].to_i,
      email: results.first["email"],
      username: results.first["username"],
      password: results.first["password"],
      admin: results.first["admin"] == "t"
    })
  end

  def self.find_email(email)
    results = DB.exec("SELECT * FROM users WHERE email = '#{email}';")
    User.new({
      id: results.first["id"].to_i,
      patron_id: results.first["patron_id"].to_i,
      email: results.first["email"],
      username: results.first["username"],
      password: results.first["password"],
      admin: results.first["admin"] == "t"
    })
  end

  def ==(other_user)
    (@id == other_user.id) &
    (@patron_id == other_user.patron_id) &
    (@email == other_user.email) &
    (@username == other_user.username) &
    (@admin == other_user.admin)
  end
end
