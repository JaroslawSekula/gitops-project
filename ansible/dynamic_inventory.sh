#!/bin/bash

REGION="us-east-1"

# Pobierz dane EC2: prywatny IP + tag Name
INSTANCES=$(aws ec2 describe-instances \
  --region "$REGION" \
  --filters Name=instance-state-name,Values=running \
  --query "Reservations[*].Instances[*].[PrivateIpAddress, Tags[?Key=='Name']|[0].Value]" \
  --output json)

# Inicjalizacja struktur
declare -A HOSTVARS
prod=()
dev=()
stage=()

# Przetwórz dane
for row in $(echo "$INSTANCES" | jq -c '.[][]'); do
  ip=$(echo "$row" | jq -r '.[0]')
  name=$(echo "$row" | jq -r '.[1]')
  lname=$(echo "$name" | tr '[:upper:]' '[:lower:]')

  # Pomiń bastiony
  if [[ "$lname" == *bastionhost* || -z "$ip" || -z "$name" ]]; then
    continue
  fi

  # Dodaj do hostvars
  HOSTVARS["$name"]="{\"ansible_host\": \"$ip\"}"

  # Grupowanie
  if [[ "$lname" == *prod* ]]; then
    prod+=("\"$name\"")
  elif [[ "$lname" == *dev* ]]; then
    dev+=("\"$name\"")
  elif [[ "$lname" == *stage* ]]; then
    stage+=("\"$name\"")
  fi
done

# Budowa inventory JSON
echo "{"
echo "  \"_meta\": {"
echo "    \"hostvars\": {"
for host in "${!HOSTVARS[@]}"; do
  echo "      \"$host\": ${HOSTVARS[$host]},"
done | sed '$ s/,$//'
echo "    }"
echo "  },"

echo "  \"prod\": { \"hosts\": [${prod[*]}] },"
echo "  \"dev\": { \"hosts\": [${dev[*]}] },"
echo "  \"stage\": { \"hosts\": [${stage[*]}] }"
echo "}"
