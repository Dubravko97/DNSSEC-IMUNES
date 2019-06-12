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

for i in $dns_servers
do
    rm -f DNS_files/$i/K*.key
    rm -f DNS_files/$i/K*.private
done

cd DNS_files

for i in $dns_servers
do
    himage $i@$eid mkdir -p /var/named/etc/namedb
    hcp $i/* $i@$eid:/var/named/etc/namedb
done

himage aRootServer dnssec-keygen -K /var/named/etc/namedb/ -a RSASHA256 -b 2048 -n ZONE .
himage aRootServer dnssec-keygen -K /var/named/etc/namedb/ -a RSASHA256 -b 4096 -f KSK  -n ZONE .
# himage aRootServer dnssec-signzone -o . -t -R -S -K /var/named/etc/namedb/ /var/named/etc/namedb/root

himage dnsHr dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 2048 -n ZONE hr
himage dnsHr dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 4096 -f KSK -n ZONE hr
# himage dnsHr rndc sign hr
# himage dnsHr dig -t soa hr +dnssec +multiline @127.0.0.1
 
himage dnsCom dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 2048 -n ZONE com
himage dnsCom dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 4096 -f KSK -n ZONE com
# himage dnsCom rndc sign com
# himage dnsCom dig -t soa com +dnssec +multiline @127.0.0.1

himage dnsOrg dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 2048 -n ZONE org
himage dnsOrg dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 4096 -f KSK -n ZONE org
# himage dnsOrg rndc sign org
# himage dnsOrg dig -t soa org +dnssec +multiline @127.0.0.1

himage dnsFer dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 2048 -n ZONE fer.hr
himage dnsFer dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 4096 -f KSK -n ZONE fer.hr
# himage dnsFer rndc sign fer
# himage dnsFer dig -t soa fer.hr +dnssec +multiline @127.0.0.1

himage dnsTel dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 2048 -n ZONE tel.fer.hr
himage dnsTel dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 4096 -f KSK -n ZONE tel.fer.hr
# himage dnsTel rndc sign tel
# himage dnsTel dig -t soa tel.fer.hr +dnssec +multiline @127.0.0.1

himage dnsZpm dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 2048 -n ZONE zpm.fer.hr
himage dnsZpm dnssec-keygen -K /var/named/etc/namedb/ -a rsasha256 -b 4096 -f KSK -n ZONE zpm.fer.hr
# himage dnsZpm rndc sign zpm
# himage dnsZpm dig -t soa zpm.fer.hr +dnssec +multiline @127.0.0.1

# Kopiraj nove kljuceve:
for i in $dns_servers
do
    cd $i
    hcp $i@$eid:/var/named/etc/namedb/K* .
    cd ..
done

