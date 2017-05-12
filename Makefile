all: smoketest

.vagrant/machines/default/virtualbox/action_provision: Vagrantfile
	# Make sure we re-create the box when the Vagrantfile changes
	vagrant destroy -f && true
	vagrant up --no-provision --provider=virtualbox

vagrantup: .vagrant/machines/default/virtualbox/action_provision ## Start Vagrant box, without provisioning

vagrantprovision: vagrantup ## Provision an already started Vagrant box
	vagrant provision

smoketest: runhelloworld ## Run simple smoketests
	./VM/tests/smoke.sh
	@echo "Smoke tests have passed, you should be able to run the following and get output:"
	@echo "curl http://192.168.33.10:8080"

buildhelloworld: vagrantprovision ## Build hello-world container (inside Vagrant box to avoid local deps)
	vagrant ssh -c 'cd /vagrant/containers/hello-world/; sudo docker build -t localhost:5000/hello-world .'

pushhelloworld: buildhelloworld ## Push hello-world container to local registry
	vagrant ssh -c 'cd /vagrant/containers/hello-world/; sudo docker push localhost:5000/hello-world'

runhelloworld: pushhelloworld ## Ensure that the hello-world container is set up in systemd
	#This doesn't use Ansible or similar, since it's being considered a "deployment"
	vagrant ssh -c 'sudo cp /vagrant/containers/hello-world/unitfile.conf /etc/systemd/system/docker-nginx-hello-world.service; sudo systemctl daemon-reload; sudo systemctl restart docker-nginx-hello-world'

help:
	#Allow inline help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/:.*##/: /' | sort

destroy: ## Destroy Vagrant box
	vagrant destroy -f
