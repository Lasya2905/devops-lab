# Experiment 8: first manifest (works on macOS and Linux)
file { '/tmp/hello_puppet.txt':
  ensure  => file,
  content => "Hello from Puppet\n",
  mode    => '0644',
}

exec { 'save_date':
  command => '/bin/date > /tmp/puppet_date.txt',
  creates => '/tmp/puppet_date.txt',
}

notify { 'Puppet manifest applied successfully': }
