# frozen_string_literal: true

require "mina/rails"
require "mina/git"
# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
require "mina/rvm"    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, "AutArch"
set :domain, "188.68.57.138"
set :deploy_to, "/home/rails/AutArch"
set :repository, "git@github.com:kevin-klein/dfg.git"
set :branch, "main"

# Optional settings:
set :user, "rails"
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
# set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

set :compiled_asset_path, ["public/assets", "public/packs"]
set :asset_dirs, ["vendor/assets/", "app/assets/", "app/javascript/"]
set :shared_dirs, fetch(:shared_dirs, []).push("storage", "log", "models", "tmp", "lib/target", *fetch(:compiled_asset_path))

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :"rvm:use", "ruby-3.1.2@default"
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # command %{rbenv install 2.5.3 --skip-existing}
  command %(rvm install ruby-3.1.2)
  # command %{gem install bundler}
end

task :compile_ext do
  command %(cd image_processing)
  command %(ruby extconf.rb)
  command "make"
end

task "yarn:install" do
  command %(yarn install)
end

task "res:build" do
  command %(yarn res:build)
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :"git:clone"
    invoke :"deploy:link_shared_paths"
    invoke :"bundle:install"
    invoke :"yarn:install"
    invoke :"res:build"
    invoke :compile_ext
    invoke :"rails:db_migrate"
    invoke :"rails:assets_precompile"
    invoke :"deploy:cleanup"

    on :launch do
      in_path(fetch(:current_path)) do
        command %(mkdir -p tmp/)
        command %(touch tmp/restart.txt)
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before or after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
