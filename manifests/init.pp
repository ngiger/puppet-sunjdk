#!/usr/bin/ruby
# Follow https://wiki.debian.org/JavaPackage
# Nachteil des webupd8team ist, dass immer versucht wird via den proxy von apt-get die Datei zu holen
# Nachteil hier: die exakte Version muss angegeben werden

class sunjdk(
  $download_dir = '/opt/downloads',
  $version = '7u51-b13/jdk-7u51-linux-x64.tar.gz',
  $ensure  = present,
) {
  if ("$ensure" == 'absent' ) {
    package {['java-package','oracle-j2sdk1.7']: ensure => absent}
  } else {

    ensure_packages['java-package']
    $downloaded = "$download_dir/$version"

    $java_dir = dirname("$downloaded")
    exec{"$java_dir":
      command => "/bin/mkdir -p $java_dir && /bin/rm -f $java_dir/*.deb && /bin/chown backup $java_dir",
      creates => $java_dir,
    }
    file{$java_dir:
      ensure => directory,
      require => Exec["$java_dir"],
      owner => 'backup',
    }

    exec {
      'set-licence-selected':
        command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections',
        unless => "/usr/bin/debconf-get-selections | /bin/grep accepted-oracle-license-v1-1 | /bin/grep true";

      'set-licence-seen':
        command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections',
        unless => "/usr/bin/debconf-get-selections | /bin/grep accepted-oracle-license-v1-1 | /bin/grep true",
    }

    exec{'download_oracle_java_7':
      command =>
      "/usr/bin/wget --no-cookies --no-check-certificate --header 'Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F' http://download.oracle.com/otn-pub/java/jdk/$version",
      require => Exec[$java_dir],
      creates => "$downloaded",
      cwd => "$java_dir",
    }

    exec{'make_java_7':
      command => "/bin/echo Y | /usr/bin/fakeroot /usr/bin/make-jpkg $downloaded",
      user => "backup",
      require => Exec['download_oracle_java_7', 'set-licence-selected', 'set-licence-seen'],
      subscribe =>  Exec['download_oracle_java_7'],
      refreshonly => true,
      cwd => "$java_dir",
    }

    exec{'install_java_7':
      command =>  "/usr/bin/dpkg -i $java_dir/oracle-j2sdk1*.deb && /usr/sbin/update-java-alternatives -s j2sdk1.7-oracle",
      require => Exec['make_java_7'],
      cwd => "$java_dir",
      unless => "/usr/bin/dpkg -l oracle-j2sdk1.7",
      }
  }
}

