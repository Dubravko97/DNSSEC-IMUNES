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

echo "Kreiranje DS zapisa:"
echo ""

cd DNS_files
dir="/var/named/etc/namedb"

i="dnsTel"
echo ""
echo "Dodati u $i/tel i dnsFer/fer:"
key=`himage $i@$eid grep -r "key-signing key" $dir | cut -d: -f 1`
DS=`himage $i@$eid dnssec-dsfromkey $key`
echo $DS 

i="dnsZpm"
echo ""
echo "Dodati u $i/zpm i dnsFer/fer:"
key=`himage $i@$eid grep -r "key-signing key" $dir | cut -d: -f 1`
DS=`himage $i@$eid dnssec-dsfromkey $key`
echo $DS 

i="dnsFer"
echo ""
echo "Dodati u $i/fer i dnsHr/hr:"
key=`himage $i@$eid grep -r "key-signing key" $dir | cut -d: -f 1`
DS=`himage $i@$eid dnssec-dsfromkey $key`
echo $DS 

i="dnsHr"
echo ""
echo "Dodati u $i/hr i aRootServer/root:"
key=`himage $i@$eid grep -r "key-signing key" $dir | cut -d: -f 1`
DS=`himage $i@$eid dnssec-dsfromkey $key`
echo $DS 

i="dnsCom"
echo ""
echo "Dodati u $i/com i aRootServer/root:"
key=`himage $i@$eid grep -r "key-signing key" $dir | cut -d: -f 1`
DS=`himage $i@$eid dnssec-dsfromkey $key`
echo $DS 

i="dnsOrg"
echo ""
echo "Dodati u $i/org i aRootServer/root:"
key=`himage $i@$eid grep -r "key-signing key" $dir | cut -d: -f 1`
DS=`himage $i@$eid dnssec-dsfromkey $key`
echo $DS 

