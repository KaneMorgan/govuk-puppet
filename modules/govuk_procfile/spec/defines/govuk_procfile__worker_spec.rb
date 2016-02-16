require_relative '../../../../spec_helper'

describe 'govuk_procfile::worker', :type => :define do
  let(:title) { 'giraffe' }

  context "in non-development environments" do

    it do
      is_expected.to contain_file("/etc/init/giraffe-procfile-worker.conf").
        without_content(/manual/)
    end

    it { is_expected.to contain_service("giraffe-procfile-worker").with(:ensure => true) }
  end

  context "in development environments" do
    let(:params) { {:enable_service => false} }

    it do
      is_expected.to contain_file("/etc/init/giraffe-procfile-worker.conf").
        with_content(/^manual$/)
    end

    it { is_expected.to contain_service("giraffe-procfile-worker").with(:ensure => false) }
  end

  context "default process_type" do
    it do
      is_expected.to contain_file("/etc/init/giraffe-procfile-worker.conf").with(
        :content => /govuk_run_procfile_worker worker/
      )
    end
  end

  context "process_type is foo" do
    let(:params) { {:process_type => 'foo'} }
    it do
      is_expected.to contain_file("/etc/init/giraffe-procfile-worker.conf").with(
        :content => /govuk_run_procfile_worker foo/
      )
    end
  end
end
