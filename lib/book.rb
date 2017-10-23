#!/usr/bin/env ruby

class Book < ActiveRecord::Base
  has_many :checkouts
  has_many :patrons, through: :checkouts

  def author_name
    "#{self.author_first} #{self.author_last}"
  end
end
