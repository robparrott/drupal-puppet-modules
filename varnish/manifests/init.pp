
class varnish::install {
  package { "varnish":
    name    => "$varnish::params::package",
    ensure  => "$varnish::params::version",
  }
}

class varnish::service {
  service { "varnish":
    name => "$varnish::params::service",
    hasstatus   => true,
    hasrestart  => true,
    enable      => true,
    require     => Class["varnish::install"],
  }
}

class varnish::config {
  $backend_host = $varnish::params::backend_host
  $backend_port = $varnish::params::backend_port

  file {
    "varnish/default.vcl":
      path      => "$varnish::params::default_vcl",
      require   => Class["varnish::install"],
      notify    => Class["varnish::service"],
      content   => template("varnish/default.vcl.erb")
  }
}


class varnish {
  include varnish::install, varnish::config, varnish::service
}