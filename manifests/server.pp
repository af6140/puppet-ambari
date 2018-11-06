class ambari::server (
  $ambari_user            = 'root',
  Boolean $use_repo               = false,
  Boolean $initial_install        = true,
  Boolean $default_install        = true,
  Enum['mysq', 'postgresql'] $db_backend             = 'mysql',
  Optional[String[1]] $db_host                = undef,
  Optional[String[1]] $db_port                = undef,
  Optional[String[1]] $db_username            = undef,
  Optional[String[1]] $db_password            = undef,
  Optional[String[1]] $db_mysql_driver_url    = $::ambari::params::jdbc_driver_url,
  Boolean $db_manage_installation = false,
  Hash $settings               = {}
) inherits ::ambari::params {


  case $db_backend {
    'mysql': {
      class { '::ambari::server::db::mysql':
        manage_installation => $db_manage_installation,
        jdbc_driver_url     => $db_mysql_driver_url
      }
      if $initial_install {
        Class['::ambari::server::db::mysql'] ->
        Class['::ambari::server::setup']
      }
    }
    default: {}
  }

  anchor { '::ambari::server::start': } ->
  class { '::ambari::server::package':
    use_repo => $use_repo
  } ->
  class { '::ambari::server::service': } ->
  anchor { '::ambari::server::stop': }

  if $initial_install {
    Class['::ambari::server::package'] ->
    class { '::ambari::server::setup':
      default_install => $default_install,
      db_backend      => $db_backend,
      db_host         => $db_host,
      db_port         => $db_port,
      db_username     => $db_username,
      db_password     => $db_password
    } ->
    Class['::ambari::server::service']
  }

}
