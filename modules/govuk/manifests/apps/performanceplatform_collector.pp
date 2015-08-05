# == Class: govuk::apps::performanceplatform_collector
#
# Performance Platform collector is an application which doesn't run
# as a service. It's triggered by cron periodically to push data to
# Backdrop.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
class govuk::apps::performanceplatform_collector (
  $enabled = false,
) {
  if $enabled {
    $app = 'performanceplatform-collector'
    govuk::logstream { "${app}-production-log":
      ensure  => present,
      logfile => "/data/apps/${app}/shared/log/production.log.json",
      tags    => ['stdout', 'application'],
      fields  => {'application' => $app},
      json    => true,
    }
    logrotate::conf { "govuk-${app}":
      ensure  => present,
      matches => "/data/apps/${app}/shared/log/*.log",
    }
  }
}