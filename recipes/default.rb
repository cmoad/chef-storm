include_recipe "java::default"
include_recipe "runit"

group node["storm"]["group"]

user node["storm"]["user"] do
	gid node["storm"]["group"]
  home node["storm"]["home_dir"]
end

ark "storm" do
	version node["storm"]["version"]
	url node["storm"]["download_url"]
	checksum node["storm"]["checksum"]
	home_dir node["storm"]["home_dir"]
	action :install
end

execute "delete log and conf dirs" do
	command "rm -rf logs conf"
	cwd node["storm"]["home_dir"]
	not_if { %w(logs conf).inject(true) { |a, dir| a and
		::File.symlink?(::File.join(node["storm"]["home_dir"], dir))}}
end

[node["storm"]["local_dir"], node["storm"]["log_dir"]].each do |dir|
	directory dir do
		owner node["storm"]["user"]
		group node["storm"]["group"]
		mode 00755
		action :create
	end
end

directory node["storm"]["conf_dir"] do
	mode 00755
	action :create
end

link ::File.join(node["storm"]["home_dir"], "conf") do
	to node["storm"]["conf_dir"]
end

link ::File.join(node["storm"]["home_dir"], "logs") do
	to node["storm"]["log_dir"]
end

# If we're on OpsWorks, get hosts from the layers
if node[:opsworks]
  Chef::Log.info "Detected OpsWorks."
  if node[:opsworks][:layers]["zookeeper"]
    Chef::Log.info "Detected zookeeper layer"
    zk_nodes = []
    node[:opsworks][:layers]['zookeeper'][:instances].each do |k,v|
      zk_nodes << v
    end
  else
    zk_nodes = [node]
  end

  if node[:opsworks][:layers]["storm-nimbus"]
    Chef::Log.info "Detected nimbus layer"
    node[:opsworks][:layers]['storm-nimbus'][:instances].each do |k,v|
      nimbus = v;
    end
  else
    nimbus = node
  end

elsif Chef::Config[:solo]
    Chef::Log.warn "Chef solo does not support search, assuming Zookeeper, Nimbus and if set then drpc are on this node"
    nimbus = node
    zk_nodes = [node]
    if node['storm']['drpc']['switch']
      drpc_servers = [node]
    end
else
	nimbus = if node.recipe? "storm::nimbus"
		node
	else
		nimbus_nodes = search(:node, "recipes:storm\\:\\:nimbus AND storm_cluster_name:#{node["storm"]["cluster_name"]} AND chef_environment:#{node.chef_environment}")
		raise RuntimeError, "Nimbus node not found" if nimbus_nodes.empty?
		nimbus_nodes.sort{|a, b| a.name <=> b.name}.first
	end
	zk_nodes = search(:node, "zookeeper_cluster_name:#{node["storm"]["zookeeper"]["cluster_name"]} AND chef_environment:#{node.chef_environment}").sort{|a, b| a.name <=> b.name}
  raise RuntimeError, "This script will not work with chef client and drpc servers." if node['storm']['drpc']['switch']
end

raise RuntimeError, "No zookeeper nodes found" if zk_nodes.empty?

template ::File.join(node["storm"]["conf_dir"], "storm.yaml") do
	mode 00644
	variables :zookeeper_nodes => zk_nodes, :nimbus => nimbus, :drpc_servers => drpc_servers
end

template ::File.join(node["storm"]["home_dir"], "logback", "cluster.xml") do
  mode 00644
  source "logback.xml.erb"
end
