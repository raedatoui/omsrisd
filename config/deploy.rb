require "bundler/vlad"
require "colorize"

set :application, "risd"
set :repository, "git@github.com:raedatoui/omsrisd.git"


task :production do
  set :domain, "root@66.175.208.212"
  set :deploy_to, "/web/othermeans.business"
  set :rails_env, "production"
  set :revision, "origin/master"
  set :bundle_flags, "--deployment --without test development staging"
  set :unicorn_pid, "#{deploy_to}/current/tmp/pids/unicorn.pid"
end

set :rake_cmd, "bundle exec rake"
set :unicorn_use_bundler, true

set :deploy_tasks, %w(
  vlad:update
  vlad:bundle:install
  vlad:assets:precompile
  vlad:migrate
  vlad:start
  vlad:cleanup
)

set :setup_tasks, %w(
  vlad:setup_app
)

set :shared_paths, {
  'pids' => 'tmp/pids',
  'config/database.yml' => 'config/database.yml',
  'config/unicorn.rb' => 'config/unicorn.rb',
  'solr/data' => 'solr/data',
  'solr/pids' => 'solr/pids',
  'uploads' => 'public/uploads',
  'log' => 'log',
  'assets' => 'public/assets'
}

namespace :vlad do

  task start: [
    :stop_app,
    :start_app,
    :"solr:stop",
    :"solr:start"
  ]

  remote_task :symlink_config do
    run [
      "cd #{current_path}",
      ""
    ]
  end

  namespace :bundle do
    desc "Update OMS gem(s)"
    remote_task :oms do
      run "cd #{current_path} && bundle update oms oms-i18n"
    end
  end

  namespace :tail do
    desc "Tail the deployment logs"
    remote_task :logs do
      run "cd #{current_path} && tail -f log/#{rails_env}.log"
    end

    desc "Tail unicorn logs"
    remote_task :unicorn do
      run "cd #{current_path} && tail -f log/unicorn.log"
    end
  end

  desc "Open the deployment console"
  remote_task :console do
    run "cd #{current_path} && bundle exec rails console #{rails_env}"
  end

  namespace :solr do

    desc "Start SOLR"
    remote_task :start do
      # run "sudo service tomcat6 start"
      run "cd #{current_path} && bundle exec rake sunspot:solr:start RAILS_ENV=#{rails_env}"
    end

    desc "Stop SOLR"
    remote_task :stop do
      # run "sudo service tomcat6 stop"
      run "cd #{current_path} && bundle exec rake sunspot:solr:stop RAILS_ENV=#{rails_env}"
    end

    desc "Reindex SOLR"
    remote_task :reindex do
      run "cd #{current_path} && bundle exec rake sunspot:solr:reindex[,,true] RAILS_ENV=#{rails_env}"
    end

    desc "Recreate index file"
    remote_task :refresh do
      cmds = [
        "cd #{current_path}",
        "bundle exec rake sunspot:solr:stop RAILS_ENV=#{rails_env}",
        "rm -r ./solr/data/#{rails_env}/index",
        "bundle exec rake sunspot:solr:start RAILS_ENV=#{rails_env}",
      ]
      run cmds.join(' && ')
    end
  end

  desc "run sir-trevor migration"
  remote_task :st_migrate do
    cmds = [
      "cd #{current_path}",
      "RAILS_ENV=#{rails_env} bundle exec rake oms:sir_trevor_migration"
    ]
    run cmds.join(' && ')
  end

  namespace :download do

    desc "dump mysql database and load it locally"
    remote_task :database do
      database = run "cd #{current_path} && cat config/database.yml"
      config = YAML.load(database)[rails_env]
      filename = "#{config["database"]}.#{Time.now.strftime('%m-%d-%Y-%H-%M')}.sql.gz"
      path = "#{deploy_to}/backups/#{filename}"
      run "mysqldump -u#{config["username"]} -p#{config["password"]} #{config["database"]} | gzip > #{path}"
      sh "scp #{domain}:#{path} ."
    end

    desc "rsync images from server to local"
    task :uploads do
      cmd = "rsync -avz #{domain}:#{current_path}/public/uploads/ #{Rails.root}/public/uploads"
      puts "Running `#{cmd}`".green
      sh cmd
    end

  end

end
