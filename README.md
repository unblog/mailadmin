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

Note.

`delete-alias alias@domain.tld [target@email.tld]` – with a target, only this single association is deleted; without a target, all aliases with this source address are removed (including counter output).

`delete-domain domain.tld [--force]` – first checks if any users or aliases are still associated with the domain and, without `--force`, aborts with an error message instead of leaving orphaned entries in `virtual_users/virtual_aliases`. With `--force`, users and aliases of the domain are deleted first.