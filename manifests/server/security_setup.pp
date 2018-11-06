# setup ssl cert
class ambari::server::security_setup (
  String[1] $ssl_cert_path,
  String[1] $ssl_key_path,
  Optional[String[1]] $ssl_key_pass,
) {

  exec {'wait_for_ambari_server':
    require => Service['ambari-server'],
    command => '/usr/bin/wget --spider --tries 10 --retry-connrefused --no-check-certificate http://localhost:8080',
  }
  if $ssl_key_pass {
    $cmd = "ambari-server setup-security --security-option=setup-https --api-ssl=true --api-ssl-port=8443 --import-cert-path=${ssl_cert_path} --import-key-path=${ssl_key_path} --pem-password=${ssl_key_path}"
  }else {
    $cmd = "ambari-server setup-security --security-option=setup-https --api-ssl=true --api-ssl-port=8443 --import-cert-path=${ssl_cert_path} --import-key-path=${ssl_key_path}"
  }
  exec { 'ambari_server_security_setup':
    command => "${cmd} && touch /etc/ambari-server/conf/.security_setup",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    creates => '/etc/ambari-server/conf/.security_setup'
  }

  #notify ambari server
  Exec['ambari_server_security_setup'] ~> Service['ambari-server']

}
