class ambari::params {
  $version = '2.1.0'
  $jdbc_driver_url = 'http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.36.tar.gz'
  $service_name = 'ambari-server'
  $service_ensure = 'running'
  $service_enable = true
}
