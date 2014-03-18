Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.network :private_network, ip: "192.168.56.102"

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "precise32"]
  end

  config.vm.synced_folder "./www", "/var/www", create: true
  config.vm.synced_folder "./sqldump", "/var/sqldump", create: true

  config.vm.provision :shell, :path => "bootstrap.sh"
end
