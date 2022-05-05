#!/bin/bash
echo "check efs/qodex-metricsdb-live"

FILE=/efs/qodex-metricsdb-live/check
if [ -f "$FILE" ]; then
    echo "$FILE exists."$(date -u) >> /s3/qodex-metricsdb-live/check_ok
    echo "file exists - OK"
else
    echo "$FILE does not exist."$(date -u) >> /s3/qodex-metricsdb-live/check_fail
    cp /var/log/messages /s3/qodex-metricsdb-live/messages"$(date -u)"
    curl -X POST -H 'Content-type: application/json' --data '{"text":"EFS-qodex-metricsdb-live-TIMEOUT!!!"}' https://hooks.slack.com/services/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
    echo "file send - OK"
fi