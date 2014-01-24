define sunjdk::install (
  $filename  = undef,
  $default   = false,
  $download_from_oracle = true,
) {
  $version = $name
  if $filename == undef {
    fail('sunjdk filename must be set')
  }

  if ($download_from_oracle) {
		exec{"/root/sunjdk/${filename}":
			creates => "/root/sunjdk/${filename}",
			cwd     => "/root/sunjdk/",
			command => "/usr/bin/wget --no-cookies --no-check-certificate --header 'Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F' http://download.oracle.com/otn-pub/java/jdk/${filename}",
		}
		$jdk_requires = Exec["/root/sunjdk/${filename}"]
	} else {
    file { "/root/sunjdk/${filename}":
    ensure  => file,
    source  => "puppet:///files/${filename}",
    require => File['/root/sunjdk'],
    }
		$jdk_requires = File["/root/sunjdk/${filename}"]
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
    #    require  => $jdk_requires,
    #    notify  => Exec["chown-${version}"],
    #  }
    #}
    #/-rpm.bin$/: {
    #  exec { "jdk-rpm-bin-${filename}":
    #    cwd     => '/root/sunjdk',
    #    command => "/bin/bash /root/sunjdk/${filename} -noregister",
    #    creates => "/usr/java/${version}",
    #    require => $jdk_requires,
    #    notify  => Exec["chown-${version}"],
    #  }
    #}
    /.bin$/: {
      exec { "jdk-bin-${filename}":
        cwd     => '/usr/java',
        command => "/bin/bash /root/sunjdk/${filename} -noregister",
        creates => "/usr/java/${version}",
        require => $jdk_requires,
        notify  => Exec["chown-${version}"],
      }
    }
    /.gz$/: {
      exec { "jdk-tar-gz-${filename}":
        cwd     => '/usr/java',
        command => "/bin/tar -zxf /root/sunjdk/${filename}",
        creates => "/usr/java/${version}",
        require => $jdk_requires,
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
