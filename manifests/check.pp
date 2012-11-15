class sunjdk::check {
  file { '/usr/bin/java':
    ensure  => link,
    target  => '/etc/alternatives/java',
    seluser => 'unconfined_u',
  }
  file { '/usr/bin/javac':
    ensure  => link,
    target  => '/etc/alternatives/javac',
    seluser => 'unconfined_u',
  }
  file { '/etc/alternatives/java':
    ensure  => link,
    target  => '/usr/java/latest/jre/bin/java',
    seluser => 'unconfined_u',
  }
  file { '/etc/alternatives/javac':
    ensure  => link,
    target  => '/usr/java/latest/bin/javac',
    seluser => 'unconfined_u',
  }
}
