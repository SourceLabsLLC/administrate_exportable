# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require "rails/all"
require "dummy/config/environment"

# Setup test database
ActiveRecord::Tasks::DatabaseTasks.drop_current
ActiveRecord::Tasks::DatabaseTasks.create_current
ActiveRecord::Tasks::DatabaseTasks.load_schema_current

require "rspec/rails"
require "administrate_exportable"
require "spec_helper"
