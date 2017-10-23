#!/usr/bin/env ruby

require 'spec_helper'

describe 'Checkout' do
  let :checkout { Checkout.new({
    book_id: 1,
    patron_id: 2,
    checkout_date: "2017-09-20"
  }) }

  describe "book" do
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

  # describe ".overdue" do
  #   it "returns a list of all overdue checkouts" do
  #     checkout.save
  #     overdue_checkout = Checkout.new({book_id: 1, patron_id: 2, checkout_date: "2017-07-20"})
  #     overdue_checkout.save
  #     expect(Checkout.overdue).to eq [overdue_checkout]
  #   end
  # end
end
