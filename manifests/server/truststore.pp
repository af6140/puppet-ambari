# setup ssl cert
class ambari::server::truststore (
  String[1] $trust_store_path='/var/lib/ambari-server/keys/keystore.p12',
  String[1] $trust_store_pass='Changeme',
  Array[String[1]] $cert_paths=[],
) {
  if size($cert_paths) >0 {
    $cmd = "ambari-server setup-security --security-option=setup-truststore --truststore-path=${trust_store_path} --truststore-type=pkcs12 --truststore-password=${trust_store_pass}  --truststore-reconfigure"
    exec { 'ambari_server_truststore_setup':
      command => "${cmd} && touch /etc/ambari-server/conf/.truststore_setup",
      path    => '/bin:/sbin:/usr/bin:/usr/sbin',
      creates => '/etc/ambari-server/conf/.truststore_setup',
    }

    $cert_paths.each |$cert | {
      $cert_path_spec=split($cert, '/')
      $cert_file=$cert_path_spec[-1]
      $cert_name=regsubst($cert_file, '\.crt$', '')
      $import_cmd="ambari-server setup-security --security-option=import-certificate --truststore-path=${trust_store_path}  --truststore-type=pkcs12 --truststore-password=${trust_store_path} --import-cert-path=${cert} --import-cert-alias=${cert_name} --truststore-reconfigure"
      exec {"setup_cert_${cert_name}":
        command => "${cmd} && touch /etc/ambari-server/conf/.truststore_setup",
        path    => '/bin:/sbin:/usr/bin:/usr/sbin',
        creates => "/etc/ambari-server/conf/.setup_cert_${cert_name}",
        require => Exec['ambari_server_truststore_setup'],
        notify => Service['ambari-server'],
      }
    }
  }

}
