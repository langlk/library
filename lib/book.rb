#!/usr/bin/env ruby

class Book < ActiveRecord::Base
  has_many :checkouts
  has_many :patrons, through: :checkouts

  def author_name
    "#{self.author_first} #{self.author_last}"
  end

  def checked_in?
    self.checkouts.each do |checkout|
      if !checkout.checked_in
        return false
      end
    end
    return true
  end
end
