#!/bin/bash

function usage {
cat <<EOF
Usage ./delete-labels.sh -r <RESOURCE> -n <NAMESPACE>
Options:
  -r <RESOURCE>  # RESOURCE (RC OR DEPLOYMENT)
  -n <NAMESPACE> # NAMESPACE
EOF
exit 2
}

if [[ $# -eq 0 ]]; then
	usage
else
	while getopts ":hr:n:h:" OPTIONS; do
		case "${OPTIONS}" in
			r) RESOURCE=${OPTARG} ;;
			n) NAMESPACE=${OPTARG} ;;
			h) usage ;;
			*) usage ;;
		esac
	done
fi


components=$(kubectl get $RESOURCE -n $NAMESPACE | tail -n +2  | awk '{print $1}')
#set -x
for c in $components ; do
	all_labels=$(kubectl get $RESOURCE $c -n $NAMESPACE -o json | jq -r .metadata.labels)
	labels=$(echo "$all_labels" | grep -v 'client')
	kubectl patch $RESOURCE $c -n $NAMESPACE --patch '"metadata": { "labels": }'
	kubectl patch $RESOURCE $c -n $NAMESPACE --patch "\"metadata\": { \"labels\": $labels }"
done

