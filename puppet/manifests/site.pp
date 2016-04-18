node 'apache.vm' {

  # Configure apache
  class { 'apache':
    default_vhost => false,
  }
  include apache::mod::php
  include apache::mod::ldap

  apache::vhost { $::fqdn:
    port    => '80',
    docroot => '/var/www/test',
    require => File['/var/www/test'],
  }

  # Configure Docroot and index.html
  file { ['/var/www', '/var/www/test']:
    ensure => directory
  }

  file { '/var/www/test/index.php':
    ensure  => file,
    content => '<?php echo \'<p>Hello World</p>\'; ?> ',
  }

  # Realise the Firewall Rule
  #Firewall <||>
}
