#!/usr/bin/env ruby

class Checkout < ActiveRecord::Base
  belongs_to :book

end
