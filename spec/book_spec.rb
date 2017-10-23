#!/usr/bin/env ruby

require 'spec_helper'

describe 'Book' do
  let :book { Book.new({
    title: "Harry Potter",
    author_first: "J. K.",
    author_last: "Rowling"
  })  }

  describe '#author_name' do
    it "returns author's first and last names, separated by a space" do
      expect(book.author_name).to eq("J. K. Rowling")
    end
  end

  describe '#checkouts' do
    it "returns all recorded checkouts for a book" do
      book.save
      checkout = Checkout.create({
        patron_id: 0,
        book_id: book.id,
        checkout_date: Date.today,
        due_date: Date.today,
        checked_in: false
        })
      expect(book.checkouts).to eq([checkout])
    end
  end

  describe '#patrons' do
    it "returns all patrons who have checked out a book" do
      book.save
      patron = Patron.create({
        first_name: 'Bob',
        last_name: 'Smith'
      })
      checkout = Checkout.create({
        patron_id: patron.id,
        book_id: book.id,
        checkout_date: Date.today,
        due_date: Date.today,
        checked_in: false
      })
      expect(book.checkouts).to eq([checkout])
    end
  end
end
