# Experiment 8: first manifest (resources: file, package, notify)
file { '/tmp/hello_puppet.txt':
  ensure  => file,
  content => "Hello from Puppet\n",
  mode    => '0644',
}

package { 'tree':
  ensure => installed,
}

notify { 'Puppet manifest applied successfully': }
