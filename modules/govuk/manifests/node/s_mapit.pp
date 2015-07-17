# == Class: govuk::node::s_mapit
#
class govuk::node::s_mapit inherits govuk::node::s_base {

  include nginx

  Govuk::Mount['/var/lib/postgresql']
  ->
  class { 'govuk_postgresql::server::standalone': }

  class { 'postgresql::server::postgis': }

}