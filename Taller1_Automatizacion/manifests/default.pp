$user       = "datum"
$group      = "datum"
$base_dir   = "/home/datum/node0"
$cassandra_dir = "/home/datum/node0/cassandra_2.1.14"
$cassandra  = "http://apache.claz.org/cassandra/2.1.14/apache-cassandra-2.1.14-bin.tar.gz"

user {$user:
  ensure      => present,
  gid         => $group,
  managehome  => true,
  require     => Group[$group]
}
group {$group:
  ensure      => present,
}

file {$base_dir:
  ensure      => directory,
  owner       => $user,
  group       => $group,
  mode        => "755",
  require     => User[$user],
}

file {$cassandra_dir:
  ensure      => directory,
  mode        => "755",
  require     => File[$base_dir],
}

file {"${base_dir}/installed":
  content     => "\nmodule installed!\n",
  require     => File[$base_dir],
}

exec{ 'DescargaCassandra':
  command     => "wget -O ${$cassandra_dir}/cassandra-2.1.14.tar.gz ${cassandra}",
  path        => ['/usr/bin','/bin'],
  timeout     => 1200,
  require     => [Package["wget"],File[$cassandra_dir]],
}

exec { "DescomprimirCassandra":
	command     => "/bin/tar -zxvf ${$cassandra_dir}/cassandra-2.1.14.tar.gz",
	cwd         => "${$cassandra_dir}",
	require     => Exec["DescargaCassandra"],
}
package {'java-1.8.0-openjdk':
  ensure      => installed
}
package {'wget':
  ensure      => installed,
}

host{ 'HostNodo2':
  name  => "nodo2",
  ip =>  "5.5.5.1"
}

host{ 'HostNodo3':
  name  => "nodo3",
  ip =>  "5.5.5.2"
}
