#!/bin/bash
echo "check efs/qodex-metricsdb-live"

FILE=/efs/metricsdb/check
if [ -f "$FILE" ]; then
    echo "file exists - OK"
else
    cp /var/log/messages /s3bucketlog/qodex-metricsdb-live/messages"$(date -u)"
    curl -X POST -H 'Content-type: application/json' --data '{"text":"EFS-qodex-metricsdb-live-TIMEOUT!!!"}' https://hooks.slack.com/services/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
    echo "file send - OK"
fi