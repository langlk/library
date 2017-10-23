#!/usr/bin/env ruby

require "spec_helper"

describe 'User' do
  let :user { User.new({
    email: "bob@email.com",
    username: "bobsmith",
    password: "password123",
    patron_id: 1
  })  }


  describe '#check_password?' do
    it "returns true if the input matches the password" do
      expect(user.check_password?("password123")).to eq(true)
    end
  end

  describe '#patron' do
    it "returns the patron a user account is connected to" do
      patron = Patron.create({
        first_name: "Bob",
        last_name: "Smith"
      })
      user.patron_id = patron.id
      user.save
      expect(user.patron).to eq(patron)
    end
  end
end
