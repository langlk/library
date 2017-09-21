#!/usr/bin/env ruby

require "spec_helper"

describe('User') do
  let(:test_user) { User.new({email: "bob@email.com", username: "bobsmith", password: "password123", patron_id: 1})}

  it "saves a user's id, email, username, password, and type" do
    expect(test_user.id).to eq(nil)
    expect(test_user.email).to eq("bob@email.com")
    expect(test_user.username).to eq("bobsmith")
    expect(test_user.admin).to eq(false)
    expect(test_user.patron_id).to eq(1)
  end

  describe('#==') do
    it "declares two users as equal when they have the same attributes" do
      user2 = User.new({email: "bob@email.com", username: "bobsmith", password: "password123", patron_id: 1})
      expect(test_user).to eq(user2)
    end
  end

  describe('#check_password?') do
    it "returns true if the input matches the password" do
      expect(test_user.check_password?("password123")).to eq(true)
    end
  end

  describe('#save') do
    it "saves a user to the database" do
      test_user.save
      expect(User.all).to eq([test_user])
    end

    it "updates a saved user's data" do
      test_user.save
      test_user.make_admin
      test_user.save
      expect(User.find_id(test_user.id).admin).to eq(true)
    end
  end

  describe('#make_admin') do
    it "makes a user an admin" do
      test_user.make_admin
      expect(test_user.admin).to eq(true)
    end
  end

  describe(".all") do
    it "returns a list of all users in the database" do
      expect(User.all).to eq([])
    end
  end


  describe('.find_id') do
    it "finds a user by their id" do
      test_user.save
      expect(User.find_id(test_user.id)).to eq(test_user)
    end
  end

  describe('.find_user') do
    it "finds a user by their username" do
      test_user.save
      expect(User.find_user("bobsmith")).to eq(test_user)
    end
  end

  describe('.find_email') do
    it "firnds a user by their email" do
      test_user.save
      expect(User.find_email("bob@email.com")).to eq(test_user)
    end
  end
end
