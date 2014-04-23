#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, David White 
#
# All rights reserved - Do Not Redistribute
#

package "nginx" do
    action :upgrade
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
end

template "/etc/nginx/nginx.conf" do
    source "nginx.conf.erb"
    owner "root"
    group "root"
    mode 0755
    notifies :start, resources(:service => "nginx")
end

nginx_site "default" do
    enable node['nginx']['default_site_enabled']
end