## A helper script to manage Dovecot mailbox users in MySQL from the CLI.

> Note. Use .mailadmin.cnf in your $HOME directory for your MySQL password.

Usage:
```bash
mailadmin add-domain domain.tld
mailadmin add-user email@domain.tld passwd123
mailadmin add-alias alias@domain.tld target@domain.tld
mailadmin password email@domain.tld passwd123
mailadmin password email@domain.tld passwd123
mailadmin list
```