'use strict';

const http = require('http');
const app = require('./server');


const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '127.0.0.1';

let passed = 0;
let failed = 0;

// Assertion helper
function assert(condition, label) {
  if (condition) {
    console.log(`PASS: ${label}`);
    passed++;
  } else {
    console.error(`FAIL: ${label}`);
    failed++;
  }
}

// HTTP GET request helper with timeout
function request(path, timeout = 5000) {
  return new Promise((resolve, reject) => {
    const req = http.get(`http://${HOST}:${PORT}${path}`, (res) => {
      let body = '';
      res.on('data', (chunk) => (body += chunk));
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, body: JSON.parse(body) });
        } catch {
          resolve({ status: res.statusCode, body });
        }
      });
    });

    req.on('error', reject);

    req.setTimeout(timeout, () => {
      req.abort();
      reject(new Error(`Request timed out: ${path}`));
    });
  });
}

// Run all tests
async function runTests(server) {
  try {
    console.log(`\nRunning tests against http://${HOST}:${PORT}\n`);

    // Test /health
    console.log('Test 1 — GET /health');
    const health = await request('/health');
    assert(health.status === 200, 'Status code is 200');
    assert(health.body.status === 'ok', 'Body.status equals "ok"');
    assert(typeof health.body.uptime === 'number', 'Body.uptime is a number');
    assert(typeof health.body.timestamp === 'string', 'Body.timestamp is a string');
    assert(typeof health.body.version === 'string', 'Body.version is a string');

    // Test unknown route
    console.log('\nTest 2 — GET /unknown-route');
    const notFound = await request('/unknown-route');
    assert(notFound.status === 404, 'Status code is 404');

    // Summary
    console.log(`\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`);
    console.log(`  Results: ${passed} passed, ${failed} failed`);
    console.log(`━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n`);

    server.close();
    process.exit(failed > 0 ? 1 : 0);

  } catch (err) {
    console.error('ERROR during tests:', err);
    server.close();
    process.exit(1);
  }
}

// Start server and run tests
const server = app.listen(PORT, HOST, () => {
  runTests(server).catch(err => {
    console.error('Test runner failed:', err);
    server.close();
    process.exit(1);
  });
});
