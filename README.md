# Docker/Vagrant "Hello World"

## Design/principals
This is a basic Docker host for local testing, with some convenience wrappers.

### Usage
There are multiple phases of the Vagrant box build, which are coordinated by a Makefile. These steps are:
* Start/configure the base VM (vagrant up)
* Start a Docker registry on the VM (docker run registry:2)
* Build a sample container, and push to registry (docker build; docker push)
* "Deploy" the built container via a SystemD unitfile
* Run smoke tests (./VM/tests/smoke.sh)

See `make help` for more details

### Box internals
The box is running on CentOS 7, with a Docker daemon. In addition, it is running a local Docker registry, to make it simpler to simulate production-like running of containers.

Configured "user" containers are run via SystemD, and are configured to automatically restart, pulling the latest version from the local registry. Note that these containers are not managed by Ansible

### Provisioning
The VM is provisioned via the Ansible playbooks in ./VM/playbooks.

The demo Docker container's build/config is in ./containers/hello-world/

### Tests
There are simple tests run from the host against the VM, mostly of the form "is this service working".
