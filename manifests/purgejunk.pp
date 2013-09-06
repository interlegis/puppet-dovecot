#purgejunk.pp

class dovecot::purgejunk (	$weekday = 'Sunday',
				$hour = '1',
				$minute = '00',
				$mailto = 'root',
				$maillocation = undef,
				$spamfldrname = 'Junk',
				$trashfldrname = 'Trash',
				$trashretention = '30d',
				$spamretention = '30d',
			 ) {
	
	if !$maillocation {
		fail("Must specify Mail Location (maillocation) variable")
	}

	file { "/usr/local/bin/purge-junk.sh":
                owner => root, group => root, mode => 775,
                content => template('dovecot/purge-junk.sh.erb'),
                require => Package["Dovecot"],
        }
        cron { "purge-junk":
                command => "/usr/local/bin/purge-junk.sh",
                user => "root",
                weekday => $weekday,
                hour => $hour,
                minute => $minute,
                ensure => present,
                environment => [
                        "MAILTO=${mailto}",
                        "SHELL=/bin/bash",
                ],
                require => [
                        File["/usr/local/bin/purge-junk.sh"],
                ],
        }


}
