#!/usr/bin/env ruby

require 'spec_helper'

describe 'Patron' do
  let :patron { Patron.new({
    :first_name => "Bob",
    :last_name => "Smith"
  }) }

  describe "full_name" do
    it "returns the full name of a patron, separated by spaces" do
      expect(patron.full_name).to eq("Bob Smith")
    end
  end

  describe "checkouts" do
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
end
