# == Class: govuk::apps::router_api
#
# Configure the router-api app on a node.
#
# === Parameters
#
# [*port*]
#   The port that router-api listens on.
#   Default: 3056
#
# [*mongodb_name*]
#   The Mongo database to be used.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*router_nodes*]
#   Array of hostname:port pairs for the router instances.  These will be used
#   when reloading routes in the router.
#
# [*vhost*]
#   Virtual host to be used by the application.
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::router_api(
  $port = 3056,
  $mongodb_name,
  $mongodb_nodes,
  $router_nodes,
  $vhost,
  $secret_key_base = undef,
) {

  validate_array($mongodb_nodes)
  validate_array($router_nodes)

  govuk::app { 'router-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    vhost              => $vhost,
  }

  Govuk::App::Envvar {
    app            => 'router-api',
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  if $mongodb_nodes != [] {
    $mongodb_nodes_string = join($mongodb_nodes, ',')
    govuk::app::envvar { "${title}-MONGODB_URI":
      varname => 'MONGODB_URI',
      value   => "mongodb://${mongodb_nodes_string}/${mongodb_name}",
    }
  }

  if $router_nodes != [] {
    govuk::app::envvar { "${title}-ROUTER_NODES":
      varname => 'ROUTER_NODES',
      value   => join($router_nodes, ','),
    }
  }
}
