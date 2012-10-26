class sunjdk::install (
  $workspace = undef
) {
  if $workspace == undef {
    fail('sunjdk::install workspace parameter is required')
  }
  file { 'jdk-rpm':
    ensure  => file,
    path    => "${workspace}/jdk-7u7-linux-x64.rpm",
    source  => 'puppet:///files/jdk-7u7-linux-x64.rpm',
    require => File[$workspace],
  }
  package { 'jdk':
    ensure   => installed,
    provider => 'rpm',
    source   => "${workspace}/jdk-7u7-linux-x64.rpm",
    require  => File['jdk-rpm'],
  }
  exec { 'update-alternatives':
    command     => "${workspace}/update-alternatives.sh",
    require     => Class['sunjdk::config'],
    subscribe   => Package['jdk'],
    refreshonly => true,
  }
}
