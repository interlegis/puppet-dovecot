#sievescript.pp

define dovecot::sievescript (	$ensure = present,
				$source = false,
				$content = false
			) {

	if !($content or $source) {
    		fail 'Please provide either $source or $content'
  	}
  	if ($content and $source) {
    		fail 'Please provide either $source OR $content'
  	}
	
	file { "/etc/dovecot/sieve/${name}.sieve":
                owner => $dovecot::mail_uid, group => $dovecot::mail_gid, mode => 774,
                require => [    Package["Dovecot"],
                                Package["dovecot-sieve"],
                                File["/etc/dovecot/sieve"],
                ],
                notify => Exec["compile sieve script $name"],
        }

	if $content {
        	File["/etc/dovecot/sieve/${name}.sieve"] {
          		content => $content,
        	}
      	} else {
        	File["/etc/dovecot/sieve/${name}.sieve"] {
          		source => $source,
        	}
      	}

	exec { "compile sieve script $name":
                cwd => "/etc/dovecot/sieve",
                command => "/usr/bin/sievec /etc/dovecot/sieve/${name}.sieve",
                logoutput => true,
                timeout => 10,
                refreshonly => true,
                notify => Service["dovecot"],
        }

}
