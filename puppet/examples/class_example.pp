# Experiment 9: class, defined type, built-in functions
class greeting (String $msg = 'Hello DevOps') {
  file { '/tmp/greeting.txt':
    ensure  => file,
    content => "${msg}\n",
  }
}

define make_file (String $text) {
  file { "/tmp/${title}.txt":
    ensure  => file,
    content => "${text}\n",
  }
}

class { 'greeting': msg => 'Welcome to Puppet Classes' }
make_file { 'demo1': text => 'created by defined type' }

$upper_name = upcase('puppet')
notice("Built-in function upcase gives: ${upper_name}")
notify { "Joined: ${join(['a','b','c'], '-')}": }
