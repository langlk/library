#!/usr/bin/env ruby

class Checkout < ActiveRecord::Base
  belongs_to :book
  belongs_to :patron
end
