#!/bin/bash

function usage {
cat <<EOF
Usage: ./location_and_lock_ip.sh -i <IP> [ -l <LOCK> ]
Options:
  -i <IP>      # (REQUIRED) Indique ip to scan
  -l <LOCK>    # (OPTIONAL) Indique option of ON/OFF for locked the ip in Google
EOF
exit 2
}

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

function ip_lock ()
{
    ip=$1

    while true; do
        echo "Select Option desired"
        echo -e "[1] Google\n[2] Iptables\n[3] Exit"
        read -p "Where is do you want to apply the rule?: " ruleoption
        case $ruleoption in
            [1]* ) ip_without_point=$(echo $1 | tr -s '.' '-');
                   read -p "Define rule name (Default \"rule-deny-request-from-$ip_without_point\"): " rname ;
                   RNAME=${rname:-"rule-deny-request-from-$ip_without_point"} ;
                   read -p "Define priority (Default \"1\"): " numberpriority ;
                   NUMBERPRIORITY=${numberpriority:=1} ;
                   read -p "Define network name (Default network \"default\"): " namenetwork ;
                   NAMENETWORK=${namenetwork:=default} ;
                   gcloud compute firewall-rules create $(echo ${RNAME,,}) --priority $NUMBERPRIORITY --direction ingress --network=$NAMENETWORK --action deny --source-ranges $ip/32 --rules all ;
                   break;;

            [2]* ) sudo iptables -A INPUT -s $ip -j DROP ;
                   sudo iptables-save ;
                   break ;;

            [3]* ) exit;;
            * ) echo "Please answer y or n.";;
        esac
    done


}
if [[ $# -eq 0 ]]; then
	usage
else
	while getopts ":i:l:h:" OPTIONS; do
		case "${OPTIONS}" in
			i) IP=${OPTARG} ;;
			l) LOCK=${OPTARG} ;;
			h) usage ;;
			*) usage ;;
		esac
	done
    if [[ -z $IP ]]; then
        usage
    fi
    if [ ! $(echo $LOCK) == "OFF" ] && [ ! $(echo $LOCK) == "off" ] \
    [ ! $(echo $LOCK) == "ON" ] && [ ! $(echo $LOCK) == "on" ]; then
        usage
    fi

fi

if valid_ip $IP ; then
    URL="freegeoip.app"
    FORMAT="json"
    LOCATION=$(curl -s https://$URL/$FORMAT/$IP)
    echo "- Information of IP: $(echo $LOCATION | jq -r '.ip') -"
    echo "-- Country name: $(echo $LOCATION | jq -r '.country_name')"
    echo "-- Region name: $(echo $LOCATION | jq -r '.region_name')"
    echo "-- City: $(echo $LOCATION | jq -r '.city')"

    if [[ -z $LOCK ]]; then
        while true; do
            read -p "Would like you locked this IP direction? (y/n): " yn
            case $yn in
                [Yy]* ) ip_lock $IP; break;;
                [Nn]* ) exit;;
                * ) echo "Please answer y or n.";;
            esac
        done
    else
        if [ $(echo $LOCK) == "ON" ] || [ $(echo $LOCK) == "on" ]; then
            ip_lock $IP
        else
            exit
        fi
    fi

else
    echo "The format of ip is invalid"
fi