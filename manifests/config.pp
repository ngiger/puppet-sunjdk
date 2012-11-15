class sunjdk::config {
  file { '/root/sunjdk/update-alternatives.sh':
    ensure  => present,
    mode    => '0555',
    source  => 'puppet:///modules/sunjdk/update-alternatives.sh',
    require => File['/root/sunjdk'],
  }
  file { '/etc/profile.d/java.sh':
    ensure => present,
    mode   => '0444',
    source => 'puppet:///modules/sunjdk/java.sh',
  }
  file { '/etc/profile.d/java.csh':
    ensure => present,
    mode   => '0444',
    source => 'puppet:///modules/sunjdk/java.csh',
  }
}
