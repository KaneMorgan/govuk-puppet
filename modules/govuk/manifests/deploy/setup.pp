# == Class: govuk::deploy::setup
#
# Setup resources required by apps. The variation of these resources should
# not require an app to be restarted. Compared to `govuk::deploy::config`.
#
class govuk::deploy::setup {
  include assets::user

  group { 'deploy':
    ensure  => 'present',
    name    => 'deploy',
  }

  user { 'deploy':
    ensure      => present,
    home        => '/home/deploy',
    managehome  => true,
    groups      => ['assets'],
    shell       => '/bin/bash',
    gid         => 'deploy',
    require     => [Group['deploy'],Group['assets']];
  }

  file { '/etc/govuk':
    ensure => directory,
  }

  file { '/var/lib/govuk':
    ensure => directory,
  }

  file { '/data':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    require => User['deploy'],
  }

  file { '/data/vhost':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    require => File['/data'],
  }

  file { '/var/apps':
    ensure => directory,
  }

  # Referenced by authorized_keys template below.
  $deploy_ssh_keys = {
    'jenkins_key'                     => extlookup('jenkins_key', 'NONE_IN_EXTDATA'),
    'jenkins_skyscape_key'            => extlookup('jenkins_skyscape_key', 'NONE_IN_EXTDATA'),
    # Production Jenkins sync to other environments.
    'jenkins_skyscape_production_key' => extlookup('jenkins_skyscape_production_key', 'NONE_IN_EXTDATA'),
    'deploy_user_data_sync_key'       => extlookup('deploy_user_data_sync_key', 'NONE_IN_EXTDATA'),
  }
  file { '/home/deploy/.ssh':
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy',
    mode   => '0700',
  }
  file { '/home/deploy/.ssh/authorized_keys':
    ensure  => present,
    owner   => 'deploy',
    group   => 'deploy',
    mode    => '0600',
    content => template('govuk/home/deploy/.ssh/authorized_keys.erb'),
  }

  unless $::govuk_platform == 'development' {

    $aws_ses_smtp_host = hiera('aws_ses_smtp_host')
    $aws_ses_smtp_username = hiera('aws_ses_smtp_username')
    $aws_ses_smtp_password = hiera('aws_ses_smtp_password')
    file { '/etc/govuk/actionmailer_ses_smtp_config.rb':
      ensure  => present,
      content => template('govuk/etc/govuk/actionmailer_ses_smtp_config.erb'),
      require => File['/etc/govuk'],
    }
  }
}
