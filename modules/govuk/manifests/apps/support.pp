# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::support($port = '3031', $enable_procfile_worker = true) {

  govuk::app { 'support':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    nginx_extra_config => '
      location /_status {
        allow   127.0.0.0/8;
        deny    all;
      }

      proxy_set_header X-Sendfile-Type X-Accel-Redirect;
      proxy_set_header X-Accel-Mapping /data/uploads/support-api/csvs/=/csvs/;

      location /csvs/ {
        internal;
        root /data/uploads/support-api;
      }',
    asset_pipeline     => true,
  }

  govuk_procfile::worker { 'support':
    enable_service => $enable_procfile_worker,
  }
}
