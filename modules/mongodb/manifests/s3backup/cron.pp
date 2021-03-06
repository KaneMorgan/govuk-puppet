# == Class: mongodb::s3backup::cron
#
# Runs a backup of MongoDB to Amazon S3 as a cron job.
#
# [*user*]
#   The user to run the cronjob as.
#
# [*backup_dir*]
#   The directory where backups are managed
#
class mongodb::s3backup::cron(
  $user = 'govuk-backup',
) {

  include backup::client
  require mongodb::s3backup::package
  require mongodb::s3backup::backup

  cron { 'mongodb-s3backup':
    command => '/usr/bin/setlock -n /var/lock/mongodb-s3backup \
    /usr/local/bin/mongodb-backup-s3',
    user    => $user,
    minute  => '*/15',
  }

  cron { 'mongodb-s3-night-backup':
    command => '/usr/bin/setlock /var/lock/mongodb-s3backup \
    /usr/local/bin/mongodb-backup-s3 daily',
    user    => $user,
    hour    => '0',
    minute  => '0',
  }

}
