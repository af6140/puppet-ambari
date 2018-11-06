class ambari::server::ldap (
  String[1] $uri,
  String $secondary_uri = '',
  Boolean $ssl = true,
  String $user_class = 'person',
  String $user_attr = 'sAMAccountName',
  String $group_class = 'group',
  String $group_attr = 'cn',
  String $member_attr = 'member',
  String $dn = 'distunguishedName',
  String $base_dn,
  String $bind_dn,
  String $bind_passwd,
) {
  $cmd = @(EOT)
    ambari-server setup-ldap \
    –ldap-url="${uri}" \
    –ldap-secondary-url="${secondary_uri}" \
    –ldap-ssl='false' \
    –ldap-user-class="${user_class}" \
    –ldap-user-attr="${user_attr}" \
    –ldap-group-class="${group_class}" \
    –ldap-group-attr="${group_attr}" \
    –ldap-member-attr="${member_attr}" \
    –ldap-dn="${dn}" \
    –ldap-base-dn="${base_dn}" \
    –ldap-referral="" \
    –ldap-bind-anonym=false \
    –ldap-manager-dn="${bind_dn}" \
    –ldap-manager-password="${bind_passwd}" \
    –ldap-save-settings \
    –truststore-type=“jks” \
    –truststore-path="${ambari::server::truststore::trust_store_path}" \
    –truststore-password="${ambari::server::truststore::trust_store_pass}"
   | EOT
   exec {'wait_for_ambari_server':
      require => Service['ambari-server'],
      command => '/usr/bin/wget --spider --tries 10 --retry-connrefused --no-check-certificate http://localhost:8080',
   } ->
   file {'/etc/ambari-server/conf/config_ldap.sh':
      mode => '0700',
      content => template('ambari/config_script.sh.erb'),
   } ~>
   exec { 'ambari_server_truststore_setup':
      command => '/etc/ambari-server/conf/config_ldap.sh',
      path    => '/bin:/sbin:/usr/bin:/usr/sbin',
      refreshonly => true,
   }
}
