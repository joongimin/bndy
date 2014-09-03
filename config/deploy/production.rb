role :app, %w{nc2.the-nuvo.com}
role :web, %w{nc2.the-nuvo.com}
role :db, %w{nc2.the-nuvo.com}
set :rails_env, 'production'
set :nginx_host, 'bndy.kr'
set :unicorn_workers, 2
set :branch, 'master'