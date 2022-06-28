#!/bin/bash
echo "check efs/shared-live"

FILE=/efs/shared/check
if [ -f "$FILE" ]; then
    echo "file exists - OK"
else
    cp /var/log/messages /s3bucketlog/shared-live/messages"$(date -u)"
    curl -X POST -H 'Content-type: application/json' --data '{"text":"EFS-shared-live-TIMEOUT!!!"}' https://hooks.slack.com/services/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
    echo "file send - OK"
fi