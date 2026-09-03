## A helper script to manage Dovecot mailbox users in MySQL from the CLI.

> Note. Use .mailadmin.cnf in your $HOME directory for your MySQL password.

Usage:
```bash
mailadmin add-domain domain.tld
mailadmin add-user email@domain.tld passwd123
mailadmin add-alias alias@domain.tld target@domain.tld
mailadmin password email@domain.tld newpasswd
mailadmin delete-user email@domain.tld
mailadmin delete-alias alias@domain.tld [target@domain.tld]
mailadmin delete-domain domain.tld [--force]
mailadmin list
```