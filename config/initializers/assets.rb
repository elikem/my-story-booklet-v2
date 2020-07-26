# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("node_modules")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# these layouts have its own unique setup (js/css etc)
Rails.application.config.assets.precompile += %w( devise.js )
Rails.application.config.assets.precompile += %w( devise.js )
Rails.application.config.assets.precompile += %w( pages.css )
Rails.application.config.assets.precompile += %w( dashboard.css )
Rails.application.config.assets.precompile += %w( stories.css )
Rails.application.config.assets.precompile += %w( users/registrations.css )
Rails.application.config.assets.precompile += %w( devise/sessions.css )
Rails.application.config.assets.precompile += %w( devise/registrations.css )
Rails.application.config.assets.precompile += %w( devise/passwords.css )
Rails.application.config.assets.precompile += %w( devise/confirmations.css )
Rails.application.config.assets.precompile += %w( devise/mailer.css )
Rails.application.config.assets.precompile += %w( devise/registrations.css )
Rails.application.config.assets.precompile += %w( publications.css )

# https://makandracards.com/makandra/29567-managing-vendor-libraries-with-the-rails-asset-pipeline
Rails.application.config.assets.paths += Dir["#{Rails.root}/vendor/asset-libs/*"].sort_by { |dir| -dir.size }
