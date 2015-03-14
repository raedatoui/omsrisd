source 'https://rubygems.org'

gem 'rails', '3.2.18'

# For seed
gem 'chronic', require: false

# For miranda seed
gem 'mechanize', require: false
gem 'reverse_markdown', require: false
gem 'colorize', require: false

# Lock to stable version
gem 'multi_json', '1.7.8'
# gem 'execjs', '1.4.0'
gem 'therubyracer'
gem 'sunspot', '2.0.0'
gem 'sunspot_solr', '2.0.0'

group :development, :test do
  gem 'sqlite3'
  gem "sunspot_test", require: false

  # Deploy with Vlad
  gem 'vlad', '2.5.1', :require => false
  gem 'vlad-git', :require => false
  gem 'vlad-unicorn', :require => false
  gem 'vlad-nginx', :require => false
  gem 'vlad-extras', :require => false

  gem 'jasmine'
  gem 'jasmine-rails', '0.4.4'
  gem 'pry'
end

group :staging do
  gem 'pg'
end

group :production, :development, :test do
  gem 'mysql2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass', '3.2.11'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
  gem 'sprockets-commonjs'
end

gem 'jquery-rails'
gem 'haml'
gem 'haml-rails'
gem 'spine-rails', git: "git://github.com/spine/spine-rails.git"
gem 'momentjs-rails', '~>2.5.0'
gem 'eco', '1.0.0'
gem 'ruby-haml-js', '0.0.5'
gem 'underscore-rails', '1.6.0'
gem 'haml_coffee_assets', '1.16.0'


gem 'oms', git: 'git@github.com:OtherMeans/oms.git', branch: 'dev'
gem 'oms-i18n', git: 'git@github.com:OtherMeans/oms-i18n.git'


gem 'htmlentities', git: "https://github.com/threedaymonk/htmlentities.git"
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem 'browsernizer', '0.2.1'

gem 'rack-a_day_without', require: 'rack/a_day_without'
