#! /bin/sh

error() {
    echo $*
    exit 2
}

dns_servers="aRootServer dnsCom dnsOrg dnsHr dnsFer dnsTel dnsZpm"

if test $# -eq 1; then
    eid=$1
else
    eid=`himage -e aRootServer`
    if test $? -ne 0; then
        exit 1
    fi
fi

cd DNS_files

for i in $dns_servers
do
    himage $i@$eid mkdir -p /var/named/etc/namedb
    hcp $i/* $i@$eid:/var/named/etc/namedb
done

cd ..

echo "Provjera konfiguracije:"
for i in $dns_servers
do
    echo "$i:"
    hcp rndc.key ${i}@${eid}:/usr/local/etc/namedb/rndc.key
    hcp bind.keys ${i}@${eid}:/usr/local/etc/namedb/bind.keys
    himage $i named-checkconf -z -c /var/named/etc/namedb/named.conf 
done

#exit 0

#
# Potpisivanje vjerojatno nije potrebno:
#
himage aRootServer dnssec-signzone -o . -t -R -S -K /var/named/etc/namedb/ /var/named/etc/namedb/root

himage dnsHr rndc sign hr
himage dnsHr dig -t soa hr +dnssec +multiline @127.0.0.1

himage dnsCom rndc sign com
himage dnsCom dig -t soa com +dnssec +multiline @127.0.0.1

himage dnsOrg rndc sign org
himage dnsOrg dig -t soa org +dnssec +multiline @127.0.0.1

himage dnsFer rndc sign fer.hr
himage dnsFer dig -t soa fer.hr +dnssec +multiline @127.0.0.1

himage dnsTel rndc sign tel.fer.hr
himage dnsTel dig -t soa tel.fer.hr +dnssec +multiline @127.0.0.1

himage dnsZpm rndc sign zpm.fer.hr
himage dnsZpm dig -t soa zpm.fer.hr +dnssec +multiline @127.0.0.1

#key=`himage dnsHr grep -r "key-signing key" /var/named/etc/namedb | cut -d: -f 1`
#himage dnsHr dnssec-dsfromkey $key

