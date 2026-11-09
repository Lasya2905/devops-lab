# Experiment 9: module "webapp" containing a class
class webapp (String $port = '80') {
  package { 'nginx':
    ensure => installed,
  }

  file { '/var/www/html/index.html':
    ensure  => file,
    content => "<h1>${webapp::greet('DevOps Student')} - served by Puppet</h1>\n",
    require => Package['nginx'],
  }

  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => Package['nginx'],
  }
}
