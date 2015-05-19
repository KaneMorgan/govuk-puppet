# == Class: govuk::node::s_api_postgresql_base
#
# Base node for s_api_postgresql_{primary,standby}
#
class govuk::node::s_api_postgresql_base inherits govuk::node::s_base {
  include govuk::apps::stagecraft::postgresql_db

  Govuk::Mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']
}