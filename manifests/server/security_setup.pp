# setup ssl cert
class ambari::server::security_setup (
  $ssl_cert_path,
  $ssl_key_path,
  $ssl_key_pass,
) {

  $cmd = "ambari-server setup-security --security-option=setup-https --api-ssl=true --api-ssl-port=8443 --import-cert-path=${ssl_cert_path} --import-key-path=${ssl_key_path} --pem-password=${ssl_key_path}"

  exec { 'run ambari-server security setup':
    command => "${cmd} && touch /etc/ambari-server/conf/.security_setup",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    creates => '/etc/ambari-server/conf/.security_setup'
  }

}
