#
# Cookbook Name:: jenkins_wrapper
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Install packages
packages = [
  'build-essential',
  'default-jdk'
]

packages.each do |pkg_id|
  package pkg_id do
    action :install
  end
end

# Install jenkins
include_recipe 'jenkins::master'

# Install plugins
plugins = [
  'git',
  'github',
  'jira',
  'hipchat',
  'bitbucket',
  'thinBackup'
]

plugins.each do |plugin_id|
  jenkins_plugin plugin_id
end

# Restart jenkins to pickup new plugins
jenkins_command 'safe-restart'

# Install nginx
include_recipe 'nginx::default'
nginx_site 'default' do
  enable false
end

# Add jenkins-nginx.conf
template '/etc/nginx/sites-available/jenkins-nginx.conf' do
  source 'jenkins-nginx.conf.erb'
  mode '0600'
  owner 'root'
  group 'root'
end

execute 'create_symlink' do
  command 'ln -sf /etc/nginx/sites-available/jenkins-nginx.conf /etc/nginx/sites-enabled/jenkins-nginx.conf'
  creates '/etc/nginx/sites-enabled/jenkins-nginx.conf'
  notifies :restart, 'service[nginx]', :immediate
end

# Tag the instance
tag('jenkins')
