Vagrant.configure("2") do |config|

	ENV["LC_ALL"] = "en_US.UTF-8"

	config.vm.box = "bento/centos-7"
	config.vm.hostname = "mariadb.example.local"

	config.vm.synced_folder ".", "/vagrant", disabled: true

    # config.vm.network :bridged
	config.vm.network "public_network", bridge: "wlp1s0", ip: "192.168.1.22"

	config.vm.provider "virtualbox" do |v|
		v.name = "mariadb"
	end
end
