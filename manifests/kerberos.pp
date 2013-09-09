#kerberos.pp

class dovecot::kerberos {
	file { "/etc/pam.d/dovecot":
                owner => root, group => root, mode => 444,
                content => template('dovecot/pam.d-dovecot.erb'), 
        }
}
