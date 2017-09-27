# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Class: stackdriver::config::debian
#
# Configures Stackdriver Agent for Debian derivatives
#
# === Parameters
#
# Use Hiera for overriding any parameter defaults
#
# ---
#
# [*sysconfig*]
# - Default - /etc/default/stackdriver-agent
# - Stackdriver configuration file
#
class stackdriver::config::debian(

  $sysconfig = '/etc/default/stackdriver-agent',

) inherits stackdriver {

  validate_string ( $sysconfig )

  file { $sysconfig:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',  # secure API key
    content => template("stackdriver/${::kernel}/${sysconfig}.erb"),
    notify  => Service[$svc],
  }

  file_line { 'stackdriver_config_loglevel':
    ensure   => present,
    path     => '/opt/stackdriver/collectd/etc/collectd.conf.tmpl',
    line     => '  LogLevel "warning"',
    match    => '^  LogLevel "info"',
    multiple => true,
    notify   => Service[$svc],
  }

}
