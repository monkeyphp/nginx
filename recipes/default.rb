#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, David White 
#
# All rights reserved - Do Not Redistribute
#

case node["platform"]
    
when "centos"
    
    remote_file "#{Chef::Config[:file_cache_path]}/nginx-release-centos-6-0.el6.ngx.noarch.rpm" do
        source "http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm"
        mode 0777
        action :create_if_missing
        backup false
    end
    
    package "nginx-release-centos-6-0.el6.ngx.noarch.rpm" do
        source "#{Chef::Config[:file_cache_path]}/nginx-release-centos-6-0.el6.ngx.noarch.rpm"
        provider Chef::Provider::Package::Rpm
        action :install
    end
    
    package "nginx" do
        action :install
    end
    
    service "nginx" do
        supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
    end
    
    # create sites-available
    directory "/etc/nginx/sites-available" do
        owner "root"
        group "root"
        mode 00644
        action :create
    end

    # create sites-enabled
    directory "/etc/nginx/sites-enabled" do
        owner "root"
        group "root"
        mode 00644
        action :create
    end

    template "/etc/nginx/nginx.conf" do
        source "nginx.conf.erb"
        owner "root"
        group "root"
        mode 0755
        notifies :start, resources(:service => "nginx")
    end
    
    # wget http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    # rpm -ivh nginx-release-centos-6-0.el6.ngx.noarch.rpm
    # http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    # {start|stop|restart|condrestart|try-restart|force-reload|upgrade|reload|status|help|configtest}
    # /etc/nginx/nginx.conf

when "ubuntu"

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

end

