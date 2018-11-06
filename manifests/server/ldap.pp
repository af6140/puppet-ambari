class ambari::server::ldap (
  Struct[
    {
      uri => String[1],
      base_dn => String[1],
      bind_dn => String[1],
      bind_passwd => String[1],
      ssl => Boolean,
      Optional[secondary_uri] => String[1],
      Optional[user_class] => String[1],
      Optional[user_attr] => String[1],
      Optional[group_class] => String[1],
      Optional[group_attr] => String[1],
      Optional[member_attr] => String[1],
      Optional[dn] => String[1]
    }
  ] $config,

) {

  if $config.dig('secondary_uri') {
    $secondary_uri = $config.dig('secondary_uri')
  }else {
    $secondary_uri  = ''
  }

  if $config.dig('user_class') {
    $user_class = $config.dig('user_class')
  }else {
    $user_class  = 'person'
  }

  if $config.dig('user_attr') {
    $user_attr = $config.dig('user_attr')
  }else {
    $user_attr  = 'sAMAccountName'
  }

  if $config.dig('group_class') {
    $group_class = $config.dig('group_class')
  }else {
    $group_class  = 'group'
  }

  if $config.dig('group_attr') {
    $user_attr = $config.dig('group_attr')
  }else {
    $user_attr  = 'group'
  }

  if $config.dig('member_attr') {
    $member_attr = $config.dig('member_attr')
  }else {
    $member_attr  = 'member'
  }


  if $config.dig('dn') {
    $dn = $config.dig('dn')
  }else {
    $dn  = 'distunguishedName'
  }

  $base_dn = $config.dig('base_dn')
  $bind_dn = $config.dig('bind_dn')
  $bind_passwd = $config.dig('bind_passwd')

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
