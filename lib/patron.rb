#!/usr/bin/env ruby

class Patron < ActiveRecord::Base
  has_one :user
  has_many :checkouts
  has_many :books, through: :checkouts

  def full_name
    self.first_name + " " + self.last_name
  end
end
