begin
  require 'vlad'
  require 'vlad-extras'
  Vlad.load scn: :git, app: :unicorn, web: :nginx
rescue LoadError
  # do nothing
end
