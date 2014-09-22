include_recipe "storm::default"

runit_service "storm-ui" do
	run_template_name "storm"
	log_template_name "storm"
  log_socket "127.0.0.1"
  log_prefix "storm-ui"
	options :daemon => "ui"
	subscribes :restart, "template[#{::File.join(node["storm"]["conf_dir"], "storm.yaml")}]"
end

runit_service "storm-nimbus" do
	run_template_name "storm"
	log_template_name "storm"
  log_socket "127.0.0.1"
  log_prefix "storm-nimbus"
  options :daemon => "nimbus"
	subscribes :restart, "template[#{::File.join(node["storm"]["conf_dir"], "storm.yaml")}]"
end
