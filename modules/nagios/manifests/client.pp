class nagios::client {

  anchor { 'nagios::client::begin':
    before => Class['nagios::client::package'],
    notify => Class['nagios::client::service'],
  }

  class { 'nagios::client::package':
    notify => Class['nagios::client::service'],
  }

  class { 'nagios::client::config':
    require => Class['nagios::client::package'],
    notify  => Class['nagios::client::service'],
  }

  class { 'nagios::client::service': }

  anchor { 'nagios::client::end':
    require => Class['nagios::client::service'],
  }

  @@nagios::host { "${::govuk_class}-${::hostname}":
    hostalias => $::fqdn,
    address   => $::ipaddress,
  }

  Nagios::Nrpe_config <| |>
  Nagios::Plugin <| |>
}
