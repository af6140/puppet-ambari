class ambari::agent::config() {

  $ambari_server = $::ambari::agent::ambari_server
  $ambari_server_port = $::ambari::agent::ambari_server_port
  $ambari_server_secure_port = $::ambari::agent::ambari_server_secure_port

  $host_name = ::ambari::agent::agent_host_name
  $public_host_name = ::ambari::agent::agent_public_host_name
  if  $host_name {
    file {'/var/lib/ambari-agent/hostname.sh':
      ensure => 'present',
      content => "#!/bin/sh\necho ${hostname}",
      mode => '0755',
      require => Package[$::ambari::agent::package_name],
      before => File['/etc/ambari-agent/conf/ambari-agent.ini']
    }
  }
  if public_host_name {
    file {'/var/lib/ambari-agent/public_hostname.sh':
      ensure => 'present',
      content => "#!/bin/sh\necho ${public_host_name}",
      mode => '0755',
      require => Package[$::ambari::agent::package_name],
      before => File['/etc/ambari-agent/conf/ambari-agent.ini']
    }
  }
  file { '/etc/ambari-agent/conf/ambari-agent.ini':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('ambari/agent/ambari-agent.ini.erb'),
    require => Class['::ambari::agent::install'],
    notify  => Service[$::ambari::agent::service_name],
  }

}
