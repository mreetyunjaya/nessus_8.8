#!/bin/sh

#B39E-3626-4048-6541-BAFD
#wget -O register.out https://plugins.nessus.org/register.php?serial=$(cat nessus.txt)
#Simple Way
#1.register here https://www.tenable.com/products/nessus/nessus-essentials
#2.wait email with activation code
#3.wget -O register.out https://plugins.nessus.org/register.php?serial=B39E-3626-4048-6541-BAFD
#4.cat register.out --->and you have hash login and pass
#5.wget -o all-2.0.tar.gz "https://plugins.nessus.org/v2/nessus.php?f=all-2.0.tar.gz&u=c587d90422bf6c5f7028dac80c0920dc&p=98ad86a2a4dd9eb41087f1f0d8b4a1ad"
#cat register.out |tail -2|tr  "\n" ":"|awk -F: '{print "curl  -o all-2.0.tar.gz -k --header \"Host: plugins.nessus.org\" \"https://52.16.241.207/get.php?f=all-2.0.tar.gz&u="$1"&p="$2}'
#curl -k --header "Host: plugins.nessus.org" "https://52.16.241.207/get.php?f=all-2.0.tar.gz&u=84f20fb9412017633d98a9ea60e0c832&p=ac1d4023e673024d421e8e811fb007bb" -o all-2.0.tar.gz



mv all-2.0.tar.gz all-2.0.tar.gz.$RANDOM
service nessusd stop
###running register script and get serial
python get_activ_code_fore_update.py 
echo Started downloading all.tr.gz
eval $(cat register.out |tail -2|tr  "\n" ":"|awk -F: '{print "curl  -o all-2.0.tar.gz -k --header \"Host: plugins.nessus.org\" \"https://52.16.241.207/get.php?f=all-2.0.tar.gz&u="$1"&p="$2"\""}')



#./nessus-plugins-update all-2.0.tar.gz
echo Started updates plugins
/opt/nessus/sbin/nessuscli update  /root/all-2.0.tar.gz
cp /opt/nessus/var/nessus/www/policy_wizards.json /opt/nessus/var/nessus/www/policy_wizards.json.bak
sed -i '/subscription_only": true,/d' /opt/nessus/var/nessus/www/policy_wizards.json
sed -i '/"manager_only": true,/d' /opt/nessus/var/nessus/www/policy_wizards.json
sed -i 's/"HomeFeed (Non-commercial use only)"/"ProfessionalFeed (Direct)"/g' /opt/nessus/var/nessus/plugin_feed_info.inc
sed -i 's/"HomeFeed (Non-commercial use only)"/"ProfessionalFeed (Direct)"/g' /opt/nessus/lib/nessus/plugins/plugin_feed_info.inc
sed -i 's/Nessus Home/Nessus/g' /opt/nessus/lib/nessus/plugins/scan_info.nasl
cp /opt/nessus/etc/nessus/nessus-fetch.db.bak /opt/nessus/etc/nessus/nessus-fetch.db
service nessusd start
