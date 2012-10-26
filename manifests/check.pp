class sunjdk::check {
  file { '/usr/bin/java':
    ensure  => link,
    target  => '/etc/alternatives/java',
    notify  => Class['sunjdk::install'],
    seluser => 'unconfined_u',
  }
  file { '/usr/bin/javac':
    ensure  => link,
    target  => '/etc/alternatives/javac',
    notify  => Class['sunjdk::install'],
    seluser => 'unconfined_u',
  }
  file { '/etc/alternatives/java':
    ensure  => link,
    target  => '/usr/java/latest/jre/bin/java',
    notify  => Class['sunjdk::install'],
    seluser => 'unconfined_u',
  }
  file { '/etc/alternatives/javac':
    ensure  => link,
    target  => '/usr/java/latest/bin/javac',
    notify  => Class['sunjdk::install'],
    seluser => 'unconfined_u',
  }
}
