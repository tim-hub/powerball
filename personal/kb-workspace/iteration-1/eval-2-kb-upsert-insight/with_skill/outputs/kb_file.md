# powerball

_Last updated: 2026-04-16_

## Overview

<!-- Add a brief description of this project's knowledge base -->


## 1 {{topic}}

<!-- Insight and knowledge of this topic -->
## API 503 errors — connection pool exhaustion fix

- Root cause: connection pool size was set to 5, but the service was receiving 50+ concurrent requests, causing pool exhaustion and 503s
- Fix: bumped pool_size to 100 and pool_timeout to 30s
- This pattern indicates connection pooling defaults are often too conservative for production traffic
- Monitor: watch for connection wait times as a leading indicator before 503s appear
