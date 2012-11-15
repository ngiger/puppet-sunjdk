class sunjdk (
  $config = {},
) {
  file { '/root/sunjdk':
    ensure => directory
  }
  file { '/usr/java':
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }
  include ::sunjdk::config
  $versions = hiera_hash('sunjdk::versions', $config['versions'])
  class { '::sunjdk::versions':
    config => $versions,
  }
  include ::sunjdk::check
}
