#!/usr/bin/env ruby

require 'spec_helper'

describe 'Checkout' do
  let :checkout { Checkout.new({
    book_id: 1,
    patron_id: 2,
    checkout_date: "2017-09-20"
  }) }

  describe "#book" do
    it "returns the book assigned to a checkout" do
      book = Book.create({
        :title => "Harry Potter",
        :author_first => "J. K.",
        :author_last => "Rowling"
      })
      checkout.book_id = book.id
      checkout.save
      expect(checkout.book).to eq(book)
    end
  end

  describe '#patron' do
    it "returns the patron assigned to a checkout" do
      patron = Patron.create({
        first_name: "Bob",
        last_name: "Smith"
      })
      checkout.patron_id = patron.id
      checkout.save
      expect(checkout.patron).to eq(patron)
    end
  end
end
