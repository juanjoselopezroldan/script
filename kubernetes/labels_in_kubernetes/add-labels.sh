#!/bin/bash

function usage {
cat <<EOF
Usage ./add-labels.sh -r <RESOURCE> -n <NAMESPACE> -c <CLIENT>
Options:
  -r <RESOURCE>  # RESOURCE (RC OR DEPLOYMENT)
  -n <NAMESPACE> # NAMESPACE
  -c <CLIENT>  # NAME CLIENT
EOF
exit 2
}

if [[ $# -eq 0 ]]; then
	usage
else
	while getopts ":hr:n:hc:h:" OPTIONS; do
		case "${OPTIONS}" in
			r) RESOURCE=${OPTARG} ;;
			n) NAMESPACE=${OPTARG} ;;
			c) CLIENT=${OPTARG} ;;
			h) usage ;;
			*) usage ;;
		esac
	done
fi


components=$(kubectl get $RESOURCE -n $NAMESPACE | tail -n +2  | awk '{print $1}')
pvc=$(kubectl get pvc -n $NAMESPACE | tail -n +2 | awk '{ print $1 }')
pv=$(kubectl get pv | grep $NAMESPACE | awk '{ print $1 }')
for c in $components ; do
	kubectl patch $RESOURCE $c -n $NAMESPACE --patch '"spec": { "template": { "metadata": { "labels": { "client": '$CLIENT' }}}}'
done
for p in $pvc ; do
	kubectl patch pvc $p -n $NAMESPACE --patch '"metadata": {"labels": { "client": '$CLIENT' }}'
done
for v in $pv ; do
	kubectl patch pv $v --patch '"metadata": {"labels": { "client": '$CLIENT' }}'
done