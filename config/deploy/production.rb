set :rbenv_type, :user
set :rbenv_ruby, "2.0.0-p451"
set :bundle_flags, nil
set :bundle_without, "development test"
set :unicorn_config_path, -> { current_path.join('config', 'unicorn.rb') }
set :unicorn_rack_env, 'production'

server 'n-at.me',
  user:  'ta',
  roles: %w{web app},
  ssh_options: {
    forward_agent: true,
    auth_methods: %w(publickey)
  }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
end

after 'deploy:publishing', 'deploy:restart'
after 'deploy:finishing', 'deploy:cleanup'