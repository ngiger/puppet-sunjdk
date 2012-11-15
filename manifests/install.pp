define sunjdk::install (
  $filename  = undef,
  $default   = false
) {
  $version = $name
  if $filename == undef {
    fail('sunjdk filename must be set')
  }
  file { "/root/sunjdk/${filename}":
    ensure  => file,
    source  => "puppet:///files/${filename}",
    require => File['/root/sunjdk'],
  }
  exec { "chown-${version}":
    command     => "/bin/chown -R root:root /usr/java/${version}",
    refreshonly => true,
  }
  case $filename {
    #/.rpm$/: {
    #  package { $filename:
    #    ensure   => installed,
    #    provider => 'rpm',
    #    source   => "/root/sunjdk/${filename}",
    #    require  => File["/root/sunjdk/${filename}"],
    #    notify  => Exec["chown-${version}"],
    #  }
    #}
    #/-rpm.bin$/: {
    #  exec { "jdk-rpm-bin-${filename}":
    #    cwd     => '/root/sunjdk',
    #    command => "/bin/bash /root/sunjdk/${filename} -noregister",
    #    creates => "/usr/java/${version}",
    #    require => File["/root/sunjdk/${filename}"],
    #    notify  => Exec["chown-${version}"],
    #  }
    #}
    /.bin$/: {
      exec { "jdk-bin-${filename}":
        cwd     => '/usr/java',
        command => "/bin/bash /root/sunjdk/${filename} -noregister",
        creates => "/usr/java/${version}",
        require => File["/root/sunjdk/${filename}"],
        notify  => Exec["chown-${version}"],
      }
    }
    /.gz$/: {
      exec { "jdk-tar-gz-${filename}":
        cwd     => '/usr/java',
        command => "/bin/tar -zxf /root/sunjdk/${filename}",
        creates => "/usr/java/${version}",
        require => File["/root/sunjdk/${filename}"],
        notify  => Exec["chown-${version}"],
      }
    }
    default: {
      fail('unknown file suffix')
    }
  }
  if $default {
    if defined(File['/usr/java/latest']) {
      fail('Only one sunjdk version can be the default')
    }
    file { '/usr/java/latest':
      ensure      => link,
      target      => "/usr/java/${version}",
      notify      => Exec['sunjdk-update-alternatives'],
    }
    exec { 'sunjdk-update-alternatives':
      command     => '/root/sunjdk/update-alternatives.sh',
      require     => Class['sunjdk::config'],
      refreshonly => true,
    }
  }
}
