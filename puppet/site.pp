# For master-agent (pull) setup: put in /etc/puppetlabs/code/environments/production/manifests/
node default {
  include webapp
}
