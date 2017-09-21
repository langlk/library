#!/usr/bin/env ruby

class User
  attr_reader :id, :email, :username, :admin, :patron_id

  def initialize(attributes)
    @id = attributes.fetch(:id) { nil }
    @patron_id = attributes[:patron_id]
    @email = attributes[:email]
    @username = attributes[:username]
    @password = attributes[:password]
    @admin = false
  end

  def check_password?(input)
    @password == input
  end

  def save
    results = DB.exec("INSERT INTO users (patron_id, email, username, password, admin) VALUES (#{@patron_id}, '#{@email}', '#{@username}', '#{@password}', #{@admin}) RETURNING id;")
    @id = results.first["id"].to_i
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
        admin: ((user["admin"] == "t") ? true : false)
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
      admin: ((results.first["admin"] == "t") ? true : false)
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
      admin: ((results.first["admin"] == "t") ? true : false)
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
      admin: ((results.first["admin"] == "t") ? true : false)
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
