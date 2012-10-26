class sunjdk (
  $workspace = '/root/sunjdk'
) {
  file { $workspace:
    ensure => directory
  }
  class { 'sunjdk::config':
    workspace => $workspace,
  }
  class { 'sunjdk::install':
    workspace => $workspace,
  }
  include sunjdk::check
}
