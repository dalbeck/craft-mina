require 'mina/git'
set :user, 'deploy'
set :repository, 'https://github.com/dalbeck/craft-mina.git'
case ENV['to']
when 'staging'
 set :domain, 'ec2-54-236-15-46.compute-1.amazonaws.com'
 set :deploy_to, '/var/www/html'
 set :branch, 'master'
when 'production'
 set :domain, 'ec2-54-236-15-46.compute-1.amazonaws.com'
 set :deploy_to, '/var/www/html'
 set :branch, 'master'
end
set :shared_paths, ['craft/config','craft/storage','/assets/images','/assets/videos']
task :setup => :environment do
 # create shared folders
 queue! %[mkdir -p "#{deploy_to}/shared/craft/config"]
 queue! %[mkdir -p "#{deploy_to}/shared/craft/storage"]
 queue! %[mkdir -p "#{deploy_to}/shared/assets/images"]
 queue! %[mkdir -p "#{deploy_to}/shared/assets/videos"]
# change project directory user group to web
 queue! %[chgrp -R web "#{deploy_to}"]
 # set project directory user permissions
 queue! %[chmod -R 774 "#{deploy_to}"]
 # make all new files and directories created under project directory inherit the same permissions
 queue! %[chmod g+s "#{deploy_to}"]
end
desc "Deploys the current version to the server."
task :deploy => :environment do
 deploy do
 invoke :'git:clone'
 invoke :'deploy:link_shared_paths'
 end
end