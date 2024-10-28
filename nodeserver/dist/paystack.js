"use strict";

/*const https = require('https')

const params = JSON.stringify({
    "email": "another@one.com",
    "amount": "25000",
    "bank_transfer": {
        "account_expires_at": "2024-09-12T13:10:00Z"
    }
})

const options = {
    hostname: 'api.paystack.co',
    port: 443,
    path: '/charge',
    method: 'POST',
    headers: {
        Authorization: 'Bearer sk_live_fa7fc034672d61eb60aeb685db05000d7f0de983',
        'Content-Type': 'application/json'
    }
}

const req = https.request(options, res => {
    let data = ''

    res.on('data', (chunk) => {
        data += chunk
    });

    res.on('end', () => {
        console.log(JSON.parse(data))
    })
}).on('error', error => {
    console.error(error)
})

req.write(params)
req.end()*/

var https = require('https');
var params = JSON.stringify({
  "email": "customer@email.com",
  "amount": "10000"
});
var options = {
  hostname: 'api.paystack.co',
  port: 443,
  path: '/transaction/initialize',
  method: 'POST',
  headers: {
    Authorization: 'Bearer sk_live_fa7fc034672d61eb60aeb685db05000d7f0de983',
    'Content-Type': 'application/json'
  }
};
var req = https.request(options, function (res) {
  var data = '';
  res.on('data', function (chunk) {
    data += chunk;
  });
  res.on('end', function () {
    console.log(JSON.parse(data));
  });
}).on('error', function (error) {
  console.error(error);
});
req.write(params);
req.end();