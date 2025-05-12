#!/bin/bash
set -eu

REGION=$1
ENV=$2

get_ip() {
  local alias=$1
  local name_tag="${ENV}_${alias}_instance"

  aws ec2 describe-instances \
    --region "$REGION" \
    --filters "Name=tag:Name,Values=$name_tag" "Name=tag:Env,Values=$ENV" "Name=instance-state-name,Values=running" \
    --query "Reservations[0].Instances[0].PrivateIpAddress" \
    --output text 2>/dev/null || echo ""
}

for alias in database memcached rabbitmq; do
  ip=$(get_ip "$alias")
  if [ -n "$ip" ]; then
    echo "$ip $alias" >> /etc/hosts
  else
    echo "Brak IP dla $alias"
  fi
done
