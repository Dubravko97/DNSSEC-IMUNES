#! /bin/sh

echo "managed-keys {"
echo "    # /usr/local/etc/namedb/bind.keys"
echo "    # Created on aRootServer (key-signing-key)"
echo -n "	"
grep 257 DNS_files/aRootServer/K* | cut -d: -f 2 \
    | sed -e 's/IN DNSKEY/initial-key/' \
          -e 's/257 3 8 /& "/' -e 's/$/";/' \
          -e 's,[a-zA-Z0-9/\+]\{56\} ,&%		,g' \
    | tr '%' '\n'
echo "};" 

