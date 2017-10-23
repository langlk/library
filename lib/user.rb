#!/usr/bin/env ruby

class User < ActiveRecord::Base
  belongs_to :patron

  def check_password?(input)
    self.password == input
  end

end
