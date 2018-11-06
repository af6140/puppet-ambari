class ambari::server::db::mysql (
  $manage_installation = false,
  $jdbc_driver_url     = ''
) {

  if $manage_installation {
    package { 'mysql-server':
      ensure => installed
    } ->
    service { 'mysqld':
      ensure => running
    }
  }

  file { '/usr/share/java':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }

  file { '/usr/share/java/mysql-connector-java-bin.jar':
    source      => $jdbc_driver_url,
    mode        => '0644'
  }

}
