#!/bin/bash
echo "check efs/qodex-timescaledb-live"

FILE=/efs/timescaledb/check
if [ -f "$FILE" ]; then
    echo "file exists - OK"
else
    cp /var/log/messages /s3bucketlog/qodex-timescaledb-live/messages"$(date -u)"
    curl -X POST -H 'Content-type: application/json' --data '{"text":"EFS-qodex-timescaledb-live-TIMEOUT!!!"}' https://hooks.slack.com/services/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
    echo "file send - OK"
fi