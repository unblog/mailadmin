#!/bin/bash
#
#    $file:mailadmin created 2026-08-20 08:35 AM CEST
#    $Id:github.com/unblog/mailadmin
#
#    Matteo <think@unblog.ch> Aug 20, 2026.
#    Copyright(c) 2010-2026 A-Enterprise GmbH.
#    https://www.a-enterprise.ch
#
#    Released under the GNU General Public License WITHOUT ANY WARRANTY.
#    See LICENSE.TXT for details.
#
#    vim: expandtab sw=4 ts=4 sts=4:
#
# Usage:
# mailadmin add-domain domain.tld
# mailadmin add-user email@domain.tld passwd123
# mailadmin add-alias alias@domain.tld target@domain.tld
# mailadmin password email@domain.tld passwd123
# mailadmin password email@domain.tld passwd123
# mailadmin list
#
# Database-settings
DB_NAME="mailserver"
DB_USER="mailadmin"

# Helper functions for running SQL
run_sql() {
    # mysql -u "$DB_USER" -e "$1" "$DB_NAME"
    mysql --defaults-extra-file=/root/.mailadmin.cnf -e "$1" "$DB_NAME"
}

# Helper function for retrieving a single value
get_sql_value() {
    # mysql -u "$DB_USER" -sN -e "$1" "$DB_NAME"
    mysql --defaults-extra-file=/root/.mailadmin.cnf -sN -e "$1" "$DB_NAME"
}

case "$1" in
    add-domain)
        if [ -z "$2" ]; then echo "Using: $0 add-domain <domain.tld>"; exit 1; fi
        run_sql "INSERT INTO virtual_domains (name) VALUES ('$2');"
        echo "Domain $2 was added."
        ;;

    add-user)
        if [ -z "$2" ] || [ -z "$3" ]; then echo "Using: $0 add-user <user@domain.tld> <passwort>"; exit 1; fi
        EMAIL="$2"
        PASSWORT="$3"
        DOMAIN=$(echo "$EMAIL" | cut -d@ -f2)

        # Domain ID determine
        DOMAIN_ID=$(get_sql_value "SELECT id FROM virtual_domains WHERE name='$DOMAIN';")
        if [ -z "$DOMAIN_ID" ]; then
            echo "Error: The domain $DOMAIN does not exist in virtual_domains. Please create it first."
            exit 1
        fi

        # Password-Hash via Dovecot
        HASH=$(doveadm pw -s SHA512-CRYPT -p "$PASSWORT")

        # Register user
        run_sql "INSERT INTO virtual_users (domain_id, password, email) VALUES ('$DOMAIN_ID', '$HASH', '$EMAIL');"
        echo "User $EMAIL was successfully created.."
        ;;

    password)
        if [ -z "$2" ] || [ -z "$3" ]; then echo "Using: $0 password <user@domain.tld> <neues-passwort>"; exit 1; fi
        HASH=$(doveadm pw -s SHA512-CRYPT -p "$3")
        if run_sql "UPDATE virtual_users SET password='$HASH' WHERE email='$2';"; then
            echo "Password for $2 has been updated."
        else
            echo "Error: Password update failed."
            exit 1
        fi
        ;;

    add-alias)
        if [ -z "$2" ] || [ -z "$3" ]; then echo "Using: $0 add-alias <alias@domain.tld> <ziel@email.tld>"; exit 1; fi
        SOURCE="$2"
        DEST="$3"
        DOMAIN=$(echo "$SOURCE" | cut -d@ -f2)

        DOMAIN_ID=$(get_sql_value "SELECT id FROM virtual_domains WHERE name='$DOMAIN';")
        if [ -z "$DOMAIN_ID" ]; then
            echo "Error: The domain $DOMAIN does not exist."
            exit 1
        fi

        run_sql "INSERT INTO virtual_aliases (domain_id, source, destination) VALUES ('$DOMAIN_ID', '$SOURCE', '$DEST');"
        echo "Alias $SOURCE -> $DEST was created."
        ;;

    delete-user)
        if [ -z "$2" ]; then echo "Using: $0 delete-user <user@domain.tld>"; exit 1; fi
        run_sql "DELETE FROM virtual_users WHERE email='$2';"
        echo "User $2 was deleted."
        ;;

    list)
        echo "--- Registered Domains ---"
        run_sql "SELECT name FROM virtual_domains;"
        echo -e "\n--- Active Users ---"
        run_sql "SELECT email FROM virtual_users;"
        echo -e "\n--- Active Aliases ---"
        run_sql "SELECT source, destination FROM virtual_aliases;"
        ;;

    *)
        echo "Using: $0 {add-domain|add-user|password|add-alias|delete-user|list}"
        exit 1
        ;;
esac