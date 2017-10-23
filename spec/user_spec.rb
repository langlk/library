#!/usr/bin/env ruby

require "spec_helper"

describe('User') do
  let(:test_user) { User.new({
    email: "bob@email.com",
    username: "bobsmith",
    password: "password123",
  patron_id: 1})  }


  describe('#check_password?') do
    it "returns true if the input matches the password" do
      expect(test_user.check_password?("password123")).to eq(true)
    end
  end

end
