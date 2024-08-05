do_configure:append() {
    sed -i -e '12a\' -e 'Include /etc/ssh/sshd_config.d/*.conf\' -e '' \
	${B}/sshd_config
}
