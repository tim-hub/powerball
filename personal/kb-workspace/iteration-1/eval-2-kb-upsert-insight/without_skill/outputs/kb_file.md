# API 503 Errors — Connection Pool Misconfiguration

**Date:** 2026-04-16
**Tags:** api, performance, connection-pool, debugging, 503

## Problem

The API was randomly returning 503 errors under load.

**Root cause:** The connection pool size was set to `5`, but the service was receiving `50+` concurrent requests. Once all pool connections were exhausted, incoming requests could not acquire a connection and failed with 503.

## Fix

| Setting        | Before | After |
|----------------|--------|-------|
| `pool_size`    | 5      | 100   |
| `pool_timeout` | —      | 30s   |

## Lessons Learned

- When seeing sporadic 503s under load, check connection pool configuration early.
- `pool_size` should be sized to at least match peak concurrency, with headroom.
- Setting `pool_timeout` prevents indefinite blocking — 30s is a reasonable starting value.
- Monitor concurrent request counts vs pool size as traffic grows to avoid regression.
