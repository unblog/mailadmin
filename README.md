## A helper script to manage Dovecot mailbox users in MySQL from the CLI

A helper to easily manage mailbox users when manage Dovecot IMAP server with using mailboxes in MariaDB.

## Install
Get the script as RAW then move to sbin and make it executable.
```bash
curl -o /tmp/mailadmin.sh https://github.com/unblog/mailadmin/blob/main/mailadmin.sh
mv mailadmin.sh /usr/local/sbin/mailadmin
chmod +x /usr/local/sbin/mailadmin
```
> Note. create `.mailadmin.cnf` in your $HOME to store the mailadmin secret in MySQL.

```ini
[client]
user=mailadmin
password=passwd123
```

Usage:
```shell
mailadmin add-domain domain.tld
mailadmin add-user email@domain.tld passwd123
mailadmin add-alias alias@domain.tld dest@domain.tld
mailadmin password email@domain.tld newpasswd
mailadmin delete-user email@domain.tld
mailadmin delete-alias alias@domain.tld [dest@domain.tld]
mailadmin delete-domain domain.tld [--force]
mailadmin list
```
### under the hood
`delete-alias alias@domain.tld [dest@email.tld]` – with a destination, only this single association is deleted; without a destination, all aliases with this source address are removed (including counter output).

`delete-domain domain.tld [--force]` – first checks if any users or aliases are still associated with the domain and, without `--force`, aborts with an error message instead of leaving orphaned entries in `virtual_users/virtual_aliases`. With `--force`, users and aliases of the domain are deleted first.