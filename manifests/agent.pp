class ambari::agent(
  $package_name              = $::ambari::params::agent_pkg_name,
  $package_ensure            = $::ambari::params::agent_pkg_ensure,
  $ambari_server             = 'localhost',
  $ambari_server_port        = '8440',
  $ambari_server_secure_port = '8441',
  $service_name              = $::ambari::params::agent_service_name,
  $service_ensure            = $::ambari::params::agent_service_ensure,
  $service_enable            = $::ambari::params::agent_service_enable,
  $use_repo                  = $::ambari::params::agent_use_repo,
  Optional[String[1]] $agent_host_name=undef,
  Optional[String[1]] $agent_public_host_name=undef,
    ) inherits ::ambari::params {

  contain ::ambari::agent::install
  contain ::ambari::agent::config
  contain ::ambari::agent::service

  Class[::ambari::agent::install] ->
  Class[::ambari::agent::config] ->
  Class[::ambari::agent::service]
}
