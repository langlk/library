#!/usr/bin/env ruby
ENV['RACK_ENV'] = 'test'

require("bundler/setup")
Bundler.require(:default, :test)
set(:root, Dir.pwd())

require('capybara/rspec')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)
require('./app')

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.after(:each) do
    Book.all.each do |book|
      book.destroy
    end

    Checkout.all.each do |checkout|
      checkout.destroy
    end
    #
    # Patron.all.each do |patron|
    #   patron.destroy
    # end
    #
    # User.all.each do |user|
    #   user.destroy
    # end
  end
end
