class ambari::mpk(
  Enum['hdf'] $name='hdf',
  Enum['3.1.2.0', '3.2.0.0'] $version='3.2.0.0',
  Hash $mpk_archive_urls = {},
  String[1] $ambari_resource_path = '/var/lib/ambari-server/resources',
) {

  $mpk_urls = merge($ambari::params::default_mpk_fetch_urls, $mpk_archive_urls)
  $mpk_url = $mpk_urls[$name][$version]

  if $mpk_url {
    archive{"mpk_${name}_${version}":
      ensure => 'present',
      extract => false,
      path=> "/root/mpk_${name}_${version}.tgz",
    } ->
    exec {"install_mpk_${name}":
      command => '/etc/init.d/ambari-sever install-mpack -mpack="/root/mpk_${name}_${version}.tgz" --purge',
      path => ['/bin/', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin'],
      unless => ['test -f']
    }
  }
}
