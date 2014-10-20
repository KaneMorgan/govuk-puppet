# == Class: golang
#
# Installs goenv, along with a number of Go versions.  This is mainly intended
# for use on a dev VM.
#
class golang {
  include govuk::ppa

  class { 'goenv':
    global_version => '1.2.2',
    require        => Class['govuk::ppa'],
  }
  goenv::version { ['1.2.2', '1.3.1', '1.3.3']: }

  package { 'godep':
    ensure  => latest,
    require => Class['govuk::ppa'],
  }

  # Ensure that scm tools used by `go get` are present.
  ensure_packages(['bzr', 'git', 'mercurial'])

  # FIXME remove once cleaned up everywhere.
  package { ['golang', 'golang-doc', 'golang-go', 'golang-go-linux-amd64', 'golang-src']:
    ensure => purged,
  }
}
