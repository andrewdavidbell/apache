class ldap (
  $ldap_url,
  $ldap_bind_dn,
  $ldap_bind_password,
  $ldap_group_attribute,
  $ldap_group,
) {
  include stdlib

  validate_string($ldap_url)
  validate_string($ldap_bind_dn)
  validate_string($ldap_bind_password)
  validate_string($ldap_group_attribute)
  validate_string($ldap_group)

  # Configure apache
  class { 'apache':
    default_vhost => false,
  }

  class { 'apache::mod::php': }

  class { 'apache::mod::authnz_ldap':
    verifyServerCert => false,
  }

  # Configure Docroot and index.html
  file { ['/var/www', '/var/www/test']:
    ensure => directory,
  }

  apache::vhost { 'vhost.apache.vm':
    port            => '80',
    docroot         => '/var/www/test',
    custom_fragment => template('ldap/ldap.conf.erb'),
    require         => File['/var/www/test'],
  }

  file { '/var/www/test/index.php':
    ensure  => file,
    content => '<?php echo \'<p>Hello World</p>\'; ?> ',
    require => File['/var/www/test'],
  }
}
