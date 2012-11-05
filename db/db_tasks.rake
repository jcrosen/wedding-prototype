namespace :app do

  task :ensure_development_environment => :environment do
    if Rails.env.production?
      raise "\nSorry but this task should not be executed against the production environment"
    end
  end

  desc "Reset"
  task :reset => [:ensure_development_environment, "db:migrate:reset", "db:seed", "app:populate_dev"]

  desc "Load the development environment"
  task :populate_dev => [:ensure_development_environment, :environment] do
    require 'miniskirt'
    require_relative '../spec/factories/factories'
  end

end
