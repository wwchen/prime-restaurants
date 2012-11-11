# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Prime::Application.initialize!

# Logger
Rails.logger = Logger.new(STDOUT)
