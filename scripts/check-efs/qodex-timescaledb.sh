#!/bin/bash
echo "check efs/qodex-timescaledb"

FILE=/efs/qodex-timescaledb/check
if [ -f "$FILE" ]; then
    echo "$FILE exists."$(date -u) >> /s3/qodex-timescaledb/check_ok
    echo "file exists - OK"
else
    echo "$FILE does not exist."$(date -u) >> /s3/qodex-timescaledb/check_fail
    cp /var/log/messages /s3/qodex-timescaledb/messages"$(date -u)"
    curl -X POST -H 'Content-type: application/json' --data '{"text":"EFS-qodex-timescaledb-TIMEOUT!!!"}' https://hooks.slack.com/services/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
    echo "file send - OK"
fi