class sunjdk::versions (
  $config = undef
) {
  if $config {
    $defaults = {}
    create_resources('sunjdk::install', $config, $defaults)
  }
}
