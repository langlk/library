#!/usr/bin/env ruby

class User < ActiveRecord::Base

  def check_password?(input)
    self.password == input
  end

end
