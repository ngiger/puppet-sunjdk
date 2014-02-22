#!/usr/bin/ruby
# Follow https://wiki.debian.org/JavaPackage
# Nachteil des webupd8team ist, dass immer versucht wird via den proxy von apt-get die Datei zu holen
class sunjdk($version = hiera('sunjdk::version', 'latest'),
  $release = 'precise',
  $ensure  = present,
) {

  if ("$ensure" == 'absent' ) {
    package {'oracle-java7-installer': ensure => absent}
  } else {
      apt::source { 'webupd8team':
        location => "http://ppa.launchpad.net/webupd8team/java/ubuntu",
        release => "$release",
        repos => "main",
        key => "EEA14886",
        key_server => "keyserver.ubuntu.com",
        include_src => true,
      }
    exec {
      'set-licence-selected':
        command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';

      'set-licence-seen':
        command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
    }

    if (false) {
     package { 'oracle-java7-installer':
      ensure => "${version}",
      require => [Apt::Source['webupd8team'], Exec['set-licence-selected'], Exec['set-licence-seen']],
      }
    } else  {
        exec{'oracle-java7-installer':
          command     => "/usr/bin/apt-get -q -y -o DPkg::Options::=--force-confold install oracle-java7-installer",
          environment => 'http_proxy=false',
          require => [Apt::Source['webupd8team'], Exec['set-licence-selected'], Exec['set-licence-seen']],
        }
    }
  }
}

