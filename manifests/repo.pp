class ambari::repo {

  include ::ambari

  if $::osfamily == 'RedHat' {
    file { "/etc/yum.repos.d/ambari_${::ambari::version}.repo" :
      ensure => 'present',
      source      => "http://public-repo-1.hortonworks.com/ambari/centos${::operatingsystemmajrelease}/${::ambari::repo_version}/updates/${::ambari::version}/ambari.repo",
      mode        => '0644'
    }
  }

}
