# == Class: govuk_jenkins::job::deploy_cdn
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::deploy_cdn {
  file { '/etc/jenkins_jobs/jobs/deploy_cdn.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_cdn.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}