include_recipe "storm::default"

runit_service "storm-drpc" do
	run_template_name "storm"
	log_template_name "storm"
  log_socket "127.0.0.1"
  log_prefix "storm-drpc"
	options :daemon => "drpc"
	subscribes :restart, "template[#{::File.join(node["storm"]["conf_dir"], "storm.yaml")}]"
end