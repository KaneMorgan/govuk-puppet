# == Class: mongodb_legacy::config
#
# Configures a MongoDB server.
#
# === Parameters:
#
# [*dbpath*]
# [*dbpath*]
#
# [*development*]
#   Disable journalling and enable query profiling.
#   Saves space at the expense of data integrity.
#   Default: false
#
# [*oplog_size*]
#   Defines size of the oplog in megabytes.
#   If undefined, we use MongoDB's default.
#
# [*replicaset_name*]
#   A string for the name of the replicaset.
#   Passed in by `mongodb_legacy::server` which sets it to
#   'production' unless $development is true, in which
#   case it is set to 'development'.
#
class mongodb_legacy::config (
  $dbpath = '/var/lib/mongodb',
  $development,
  $oplog_size = undef,
  $replicaset_name,
) {
  validate_bool($development)

  # Class params are used in the templates below.

  file { '/etc/mongodb.conf':
    ensure  => present,
    content => template('mongodb_legacy/mongodb.conf'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
