#init.pp

class dovecot (
		$auth_mecanisms = 'plain',
		$userdb = 'static',
		$userdb_args = '',
		$passdb = 'pam',
		$passdb_args = 'dovecot',
		$mail_location = '',
		$mail_uid = undef,
		$mail_gid = undef,
		$mail_privileged_group = undef,
		$mail_dotlock_use_excl = true,
		$mail_fsync = 'optimized',
		$mail_nfs_storage = false,
		$mail_index_lock_method = undef,
		$enable_quota = false,
		$quota_rules = { },
		$quota_warnings = { },
		$quota_warning_svcs = [ ],
		$quota_backends = { },
		$quota_roots = { },
		$quota_warning_from = "postmaster@${domain}",
		$quota_warning_subject = '!!! Quota Warning !!!',
		$quota_warning_message = 'Your mailbox is $PERCENT% full. Please delete some messages or move them to Local Folders to avoid new messages from being rejected.

Yours truly,

Mail Admin
', 
		$imap_port = 143,
		$imaps_port = 993,
		$imap_login_process_limit = 100,
		$pop3_port = 110,
		$pop3s_port = 995,
		$auth_userdb_mode = '0600',
		$auth_userdb_user = undef, 				
		$auth_userdb_group = undef, 
		$ssl_support = 'no',
		$ssl_cert_file = '/etc/ssl/certs/dovecot.pem',
		$ssl_key_file = '/etc/ssl/private/dovecot.pem',
		$lda_submission_host = undef,
		$lda_mailbox_autocreate = false,
		$enable_sieve = false,
		$sieve_global_path = '/etc/dovecot/sieve/default.sieve',
		$sieve_before = '',
		$enable_postfix_auth = false,						
	) {
    	case $::operatingsystem {
    		Ubuntu : { include dovecot::ubuntu }
    		default: { fail "Operating system not supported: ${::operatingsystem}" }
  	}
}
