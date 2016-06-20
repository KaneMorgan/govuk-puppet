# == Class: govuk_elasticsearch::housekeeping
#
#  Delete old snapshots from elasticsearch
#
#
# === Parameters:
#
# [*es_repo*]
#   The local elasticsearch repository where snapshots are stored
#
# [*es_snapshot_limit*]
#   The number of snapshots we want to keep
#
# [*user*]
#   User that invokes backup
#
class govuk_elasticsearch::housekeeping(
  $es_repo = undef,
  $es_snapshot_limit = 5,
  $user = 'govuk-backup'
) {


  # This is a CLI JSON processor which allows us to "awk" the data on the fly
  package { 'jq':
    ensure => installed,
  }

  file { 'es-prune-snapshots':
    ensure  => file,
    path    => '/usr/local/bin/es-remove-old-snapshots',
    content => template('govuk_elasticsearch/es-prune-snapshots.erb'),
    owner   => $user,
    group   => $user,
    mode    => '0550',
  }

  cron { 'elasticsearch-remove-old-snapshots':
    command => '/usr/local/bin/es-prune-snapshots',
    user    => $user,
    weekday => 3,
  }
}
