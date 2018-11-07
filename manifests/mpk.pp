class ambari::mpk(
  Enum['hdf'] $mpk_name='hdf',
  Enum['3.1.2.0', '3.2.0.0'] $version='3.2.0.0',
  Hash $mpk_archive_urls = {},
  String[1] $ambari_resource_path = '/var/lib/ambari-server/resources',
) {

  $mpk_urls = merge($ambari::params::default_mpk_fetch_urls, $mpk_archive_urls)
  $mpk_url = $mpk_urls[$mpk_name][$version]

  if $mpk_url {
    $url_specs = split($mpk_url, '/')
    $gz_file_name = $url_specs[-1]
    $file_name = regsubst($gz_file_name, '\.tar\.gz$', '')

    file { "/root/${mpk_name}_${version}.tar.gz":
      ensure => 'present',
      source => $mpk_url,
    } ~>
    exec {"install_mpk_${mpk_name}":
      command => "ambari-server install-mpack -mpack=/root/${mpk_name}_${version}.tar.gz --purge",
      path => ['/bin/', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin'],
      unless => ["test -f /var/lib/ambari-server/resources/${file_name}"]
    }
  }
}
