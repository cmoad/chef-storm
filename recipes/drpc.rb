include_recipe "storm::default"

service_name = "storm-drpc"
template "/etc/init/#{service_name}.conf" do
  source "upstart.conf.erb"
  variables({
                :name => "drpc",
                :user => node[:storm][:user],
                :group => node[:storm][:group],
                :dir => node[:storm][:home_dir]
            })
end

service service_name do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
  action [:enable, :restart]
end
