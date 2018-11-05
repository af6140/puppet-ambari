class ambari::params {
  $version = '2.1.0'
  $jdbc_driver_url = 'http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.36.tar.gz'
  $service_name = 'ambari-server'
  $service_ensure = 'running'
  $service_enable = true
  $agent_pkg_name = 'ambari-agent'
  $agent_pkg_ensure = 'installed'
  $agent_service_name = 'ambari-agent'
  $agent_service_ensure = 'running'
  $agent_service_enable = true
  $agent_use_repo = true

  $default_mpk_fetch_urls = {
    'hdf' => {
      '3.1.2.0' => 'http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.1.2.0/tars/hdf_ambari_mp/hdf-ambari-mpack-3.1.2.0-7.tar.gz',
      '3.2.0.0' => 'http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.2.0.0/tars/hdf_ambari_mp/hdf-ambari-mpack-3.2.0.0-520.tar.gz'
    }
  }

}
