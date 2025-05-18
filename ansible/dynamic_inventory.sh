#!/bin/bash

REGION="us-east-1"


INSTANCES=$(aws ec2 describe-instances \
  --region "$REGION" \
  --filters Name=instance-state-name,Values=running \
  --query "Reservations[*].Instances[*].[PrivateIpAddress, Tags[?Key=='Name']|[0].Value]" \
  --output json)


declare -A HOSTVARS
prod=()
dev=()
stage=()


for row in $(echo "$INSTANCES" | jq -c '.[][]'); do
  ip=$(echo "$row" | jq -r '.[0]')
  name=$(echo "$row" | jq -r '.[1]')
  lname=$(echo "$name" | tr '[:upper:]' '[:lower:]')


  if [[ -z "$ip" || -z "$name" || "$lname" == *bastionhost* ]]; then
    continue
  fi


  HOSTVARS["$name"]="{\"ansible_host\": \"$ip\"}"


  if [[ "$lname" == *prod* ]]; then
    prod+=("$name")
  elif [[ "$lname" == *dev* ]]; then
    dev+=("$name")
  elif [[ "$lname" == *stage* ]]; then
    stage+=("$name")
  fi
done


join_array() {
  local result=""
  for item in "$@"; do
    if [[ -n "$result" ]]; then
      result+=","
    fi
    result+="\"$item\""
  done
  echo "$result"
}


prod_hosts=$(join_array "${prod[@]}")
[[ -z "$prod_hosts" ]] && prod_hosts="" || prod_hosts="$prod_hosts"

dev_hosts=$(join_array "${dev[@]}")
[[ -z "$dev_hosts" ]] && dev_hosts="" || dev_hosts="$dev_hosts"

stage_hosts=$(join_array "${stage[@]}")
[[ -z "$stage_hosts" ]] && stage_hosts="" || stage_hosts="$stage_hosts"


echo "{"
echo "  \"_meta\": {"
echo "    \"hostvars\": {"
count=0
for host in "${!HOSTVARS[@]}"; do
  ((count++))
  comma=","
  [[ $count -eq ${#HOSTVARS[@]} ]] && comma=""
  echo "      \"$host\": ${HOSTVARS[$host]}$comma"
done
echo "    }"
echo "  },"
echo "  \"prod\": { \"hosts\": [${prod_hosts}] },"
echo "  \"dev\": { \"hosts\": [${dev_hosts}] },"
echo "  \"stage\": { \"hosts\": [${stage_hosts}] }"
echo "}"