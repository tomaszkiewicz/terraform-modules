#!/bin/bash
echo "check efs/shared-live"

FILE=/efs/shared/check
if [ -f "$FILE" ]; then
    echo "file exists - OK"
else
    curl -X POST -H 'Content-type: application/json' --data '{"text":"EFS-shared-live-TIMEOUT!!!"}' https://hooks.slack.com/services/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
    echo "file send - OK"
fi

echo "check efs/qodex-timescaledb-live"

FILE=/efs/timescaledb/check
if [ -f "$FILE" ]; then
    echo "file exists - OK"
else
    curl -X POST -H 'Content-type: application/json' --data '{"text":"EFS-qodex-timescaledb-live-TIMEOUT!!!"}' https://hooks.slack.com/services/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
    echo "file send - OK"
fi

echo "check efs/qodex-metricsdb-live"

FILE=/efs/metricsdb/check
if [ -f "$FILE" ]; then
    echo "file exists - OK"
else
    curl -X POST -H 'Content-type: application/json' --data '{"text":"EFS-qodex-metricsdb-live-TIMEOUT!!!"}' https://hooks.slack.com/services/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
    echo "file send - OK"
fi