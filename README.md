## A helper script to manage Dovecot mailbox users in MySQL from the CLI

A helper to easily manage mailbox users on Dovecot IMAP server with using mailboxes in MariaDB.

## Install
Get the script as RAW move to sbin and make it executable.
```bash
curl -o /tmp/mailadmin.sh https://github.com/unblog/mailadmin/blob/main/mailadmin.sh
mv mailadmin.sh /usr/local/sbin/mailadmin
chmod +x /usr/local/sbin/mailadmin
```
Create account mailadmin with grant rights to database mailserver in MariaDB.

```sql
mysql -uroot
CREATE USER 'mailadmin'@'localhost' IDENTIFIED BY 'passwd123';
GRANT SELECT, INSERT, UPDATE, DELETE ON mailserver.* TO 'mailadmin'@'localhost';
FLUSH PRIVILEGES;
```
_change database name `mailserver` if they use a different one._

> Note: If a password is set for the root, you must also append the -p flag (either -p for a subsequent password prompt or directly after it -pYourPassword without spaces).
> Run `doveadm pw -s SHA512-CRYPT -p 'passwd123'` for password-hash, check hashing algorithm scheme using in dovecot.conf.

Create `.mailadmin.cnf` in your $HOME to store mailadmin secret.

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