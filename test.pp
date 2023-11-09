node 'example_node' {
  file { '/etc/example.conf':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/example_module/example.conf'
  }

  cron { 'daily_cleanup':
    command     => '/usr/bin/cleanup.sh',
    minute      => '0',
    hour        => '2',
    monthday    => '*',
    month       => '*',
    weekday     => '*'
  }
}
