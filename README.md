# storm cookbook
This cookbook installs and configures [Storm](http://storm-project.net/)

# Requirements
Zookeeper cluster, should be installed using the zookeeper cookbook (see berksfile). The `zookeeper_cluster_name` attribute should match Zookeeper's `node["zookeeper"]["cluster_name"]` attribute.

# Usage
`include_recipe "storm::supervisor"` on the supervisor nodes, `include_recipe "storm::nimbus"` on the nimbus node.

# Attributes

# Recipes
storm::default - Installs storm files, configures directories, etc.
storm::nimbus - nimbus and UI services
storm::supervisor - supervisor daemon

# Acknowledgements
Thanks to the authors of cookbooks from which this is derived:

* [Webtrends/storm](https://github.com/Webtrends/storm)
* [fewbytes-cookbooks/storm](https://github.com/fewbytes-cookbooks/storm)
* [kapad/storm](https://github.com/kapad/storm)
