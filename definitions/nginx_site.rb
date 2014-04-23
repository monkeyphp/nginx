#
# Cookbook Name:: nginx
# Definition:: nginx_site
#
define :nginx_site, :enable => true do
    include_recipe 'nginx::default'
    if params[:enable]
        link "#{node['nginx']['dir']}/sites-enabled/#{params[:name]}" do
            to "#{node['nginx']['dir']}/sites-available/#{params[:name]}"
            action :create
            only_if do
                ::File.exists?("#{node['nginx']['dir']}/sites-available/#{params[:name]}")
            end
        end
    else
        link "#{node['nginx']['dir']}/sites-enabled/#{params[:name]}" do
            action :delete
            only_if do
                ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/#{params[:name]}")
            end
        end
    end
end