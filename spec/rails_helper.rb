# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'

require 'rails/all'

system({"RAILS_ENV" => "test"}, "cd spec/dummy ; bin/rails db:reset")

require 'dummy/config/environment'
require 'rspec/rails'
require 'administrate_exportable'
require 'spec_helper'
