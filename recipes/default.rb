#
# Cookbook Name:: jenkins_wrapper
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Install packages
packages = [
  'build-essential',
  'openjdk-8-jdk'
]

packages.each do |pkg_id|
  package pkg_id do
    action :install
  end
end

# Install jenkins
node.override[:jenkins][:master][:jvm_options] = '-Djenkins.install.runSetupWizard=false'
node.default[:jenkins][:master][:repository] = 'http://pkg.jenkins-ci.org/debian-stable'
node.default[:jenkins][:master][:repository_key] = 'http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key'
node.default[:jenkins][:master][:version] = '2.7.1'

include_recipe 'jenkins::master'

# Get admin password
admin_pwd = ''
ruby_block 'get_admin_pwd' do
  block do
    if File.exist?('/var/lib/jenkins/secrets/initialAdminPassword')
      admin_pwd = IO.read('/var/lib/jenkins/secrets/initialAdminPassword')
    end
  end
end
log 'Admin password is: ' + admin_pwd

# Install plugins
plugins = [
  'git',
  'github',
  'jira',
  'bitbucket',
  'thinBackup'
]

plugins.each do |plugin_id|
  jenkins_plugin plugin_id
end

service "jenkins" do
  action :restart
end

tag('jenkins')
