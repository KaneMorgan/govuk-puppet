# == Class: govuk::node::s_mongo
#
# mongo node
#
class govuk::node::s_mongo inherits govuk::node::s_base {
  include mongodb_legacy::server

  collectd::plugin::tcpconn { 'mongo':
    incoming => 27017,
    outgoing => 27017,
  }

  Govuk_mount['/var/lib/mongodb'] -> Class['mongodb_legacy::server']
  Govuk_mount['/var/lib/automongodbbackup'] -> Class['mongodb_legacy::backup']
}
