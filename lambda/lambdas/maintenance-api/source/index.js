'use strict';

exports.handler = (event, context, callback) => {
  const response = {};
   // during maintenance we want to show 503 error due to google indexing issues
  response.status = '503';
  response.statusDescription = 'Under maintenance';
  response.headers = {};
  response.headers["retry-after"] = [{
    key: 'Retry-After',
    value: '86400',
  }]
  callback(null, response);
};