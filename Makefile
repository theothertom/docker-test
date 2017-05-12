all: smoketest

.vagrant/machines/default/virtualbox/action_provision: Vagrantfile
	# Make sure we re-create the box when the Vagrantfile changes
	vagrant destroy -f && true
	vagrant up --no-provision --provider=virtualbox

vagrantup: .vagrant/machines/default/virtualbox/action_provision ## Start Vagrant box, without provisioning

vagrantprovision: vagrantup ## Provision an already started Vagrant box
	vagrant provision

smoketest: vagrantprovision ## Run simple smoketests
	./VM/tests/smoke.sh

help:
	#Allow inline help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/:.*##/: /' | sort
