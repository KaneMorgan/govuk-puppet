# == Class: monitoring::event_handlers
#
# Configure Icinga event handlers that run on the monitoring machine
#
class monitoring::event_handlers () {

  file { '/usr/local/bin/event_handlers':
    ensure => directory,
  }

  include monitoring::event_handler::app_high_memory

}
