#!/usr/bin/env ruby

require 'spec_helper'

describe 'Patron' do
  let :patron { Patron.new({
    :first_name => "Bob",
    :last_name => "Smith"
  }) }

  describe "#full_name" do
    it "returns the full name of a patron, separated by spaces" do
      expect(patron.full_name).to eq("Bob Smith")
    end
  end

  describe "#checkouts" do
    it "returns all of a patron's checkouts" do
      patron.save
      checkout = Checkout.create({
        :patron_id => patron.id,
        :book_id => 0,
        :checkout_date => Date.today,
        :due_date => Date.today,
        :checked_in => false
      })
      expect(patron.checkouts).to eq([checkout])
    end
  end

  describe "#books" do
    it "returns all books a patron has checked out" do
      patron.save
      book = Book.create({
        title: "Harry Potter",
        author_first: "J. K.",
        author_last: "Rowling"
      })
      checkout = Checkout.create({
        patron_id: patron.id,
        book_id: book.id,
        checkout_date: Date.today,
        due_date: Date.today,
        checked_in: false
      })
      expect(patron.books).to eq([book])
    end
  end

  describe '#user' do
    it "returns the user account associated with the patron" do
      patron.save
      user = User.create({
        email: "bob@email.com",
        username: "bobsmith",
        password: "password123",
        patron_id: patron.id
      })
      expect(patron.user).to eq(user)
    end
  end
end
