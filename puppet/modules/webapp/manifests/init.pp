# Experiment 9: module "webapp" containing a class
# manage_nginx = true  -> Linux (installs nginx)
# manage_nginx = false -> macOS (only writes the page)
class webapp (
  String  $docroot      = '/var/www/html',
  Boolean $manage_nginx = true,
) {
  if $manage_nginx {
    package { 'nginx': ensure => installed }
    service { 'nginx':
      ensure  => running,
      enable  => true,
      require => Package['nginx'],
    }
  }

  file { $docroot:
    ensure => directory,
  }

  file { "${docroot}/index.html":
    ensure  => file,
    content => "<h1>${webapp::greet('DevOps Student')} - served by Puppet</h1>\n",
    require => File[$docroot],
  }
}
