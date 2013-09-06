#base.pp

class dovecot::base {
	
	package { ['Dovecot', 'Dovecot IMAP', 'Dovecot POP3']:
    		ensure => present,
  	}

	service {'dovecot':
		ensure => running,
		enable => true,
		restart => "/etc/init.d/dovecot reload",
		require => Package['Dovecot'],
  	}
	
	file {'/etc/dovecot/dovecot.conf':
        	ensure => present,
        	owner => root, group => dovecot, mode => '0644',
        	notify => Service['dovecot'],
        	content => template('dovecot/dovecot.conf.erb'),
      	}

	## Config files
	file { "/etc/dovecot/conf.d/10-auth.conf":
                owner => root, group => root, mode => 444,
                content => template('dovecot/10-auth.conf.erb'),
                require => Package["Dovecot"],
		notify => Service['dovecot'],
        }
	file { "/etc/dovecot/conf.d/auth-system.conf.ext":
                owner => root, group => root, mode => 444,
                content => template('dovecot/auth-system.conf.ext.erb'),
                require => Package["Dovecot"],
		notify => Service['dovecot'],
        }
	file { "/etc/dovecot/conf.d/10-mail.conf":
                owner => root, group => root, mode => 444,
                content => template('dovecot/10-mail.conf.erb'),
                require => Package["Dovecot"],
		notify => Service['dovecot'],
        }
	file { "/etc/dovecot/conf.d/10-master.conf":
                owner => root, group => root, mode => 444,
                content => template('dovecot/10-master.conf.erb'),
                require => Package["Dovecot"],
		notify => Service['dovecot'],
        }
	file { "/etc/dovecot/conf.d/10-ssl.conf":
                owner => root, group => root, mode => 444,
                content => template('dovecot/10-ssl.conf.erb'),
                require => Package["Dovecot"],
		notify => Service['dovecot'],
        }
	file { "/etc/dovecot/conf.d/15-lda.conf":
                owner => root, group => root, mode => 444,
                content => template('dovecot/15-lda.conf.erb'),
                require => Package["Dovecot"],
                notify => Service['dovecot'],
        }
	file { "/etc/dovecot/conf.d/20-imap.conf":
                owner => root, group => root, mode => 444,
                content => template('dovecot/20-imap.conf.erb'),
                require => Package["Dovecot"],
                notify => Service['dovecot'],
        }

	## Sieve
	if $dovecot::enable_sieve == true { 
		package { ["dovecot-sieve", "dovecot-managesieved"]: ensure => "present" }
		file { "/etc/dovecot/conf.d/20-managesieve.conf":
                	owner => root, group => root, mode => 444,
                	content => template('dovecot/20-managesieve.conf.erb'),
                	require => Package[ ["Dovecot", "dovecot-sieve", "dovecot-managesieved"] ],
                	notify => Service['dovecot'],
        	}
		file { "/etc/dovecot/conf.d/90-sieve.conf":
                        owner => root, group => root, mode => 444,
                        content => template('dovecot/90-sieve.conf.erb'),
                        require => Package[ ["Dovecot", "dovecot-sieve", "dovecot-managesieved"] ],
                        notify => Service['dovecot'],
                }
		file { "/etc/dovecot/sieve":
                	owner => $dovecot::mail_uid, group => $dovecot::mail_gid, mode => 770,
                	ensure => directory,
                	require => [ 	Package["Dovecot"],
                             		Package["dovecot-sieve"],
                	],
        	}

	}

	## Quota
	if $dovecot::enable_quota == true {
		file { "/etc/dovecot/conf.d/90-quota.conf":
                        owner => root, group => root, mode => 444,
                        content => template('dovecot/90-quota.conf.erb'),
                        require => Package[ ["Dovecot", "dovecot-sieve", "dovecot-managesieved"] ],
                        notify => Service['dovecot'],
                }
		file { "/usr/local/bin/quota-warning.sh":
                	owner => root, group => root, mode => 775,
                	content => template('dovecot/quota-warning.sh.erb'),
                	require => Package["dovecot-common"],
		}
	}	

}
