# == Class: ldap::client::install
#
# Manage the installation of the ldap client package
#
class ldap::client::install inherits ldap::client {
  package { 'ldap-client':
    ensure => $ldap::client::package_ensure,
    name   => $ldap::client::package_name,
  }


  case $::osfamily {
    'FreeBSD': {
      if $ldap::client::manage_package_dependencies {
        package { 'net-ldap':
          ensure   => $ldap::client::net_ldap_package_ensure,
          name     => $ldap::client::net_ldap_package_name,
          provider => $ldap::client::net_ldap_package_provider,
        }
      }
    }
    default: {
      if (
        (versioncmp($::puppetversion, '4.0.0') > 0) or
        (versioncmp($::puppetversion, '5.0.0') > 0) or
        (versioncmp($::puppetversion, '6.0.0') > 0)){
        # Puppet 4/5/6 has its own self-contained ruby environment so install the
        # requisite packages there
        exec { '/opt/puppetlabs/puppet/bin/gem install net-ldap':
          unless => '/opt/puppetlabs/puppet/bin/gem list | grep net-ldap',
        }
      } else {
        package { 'net-ldap':
          ensure   => $ldap::client::net_ldap_package_ensure,
          name     => $ldap::client::net_ldap_package_name,
          provider => $ldap::client::net_ldap_package_provider,
        }
      }
    }
  }
}
