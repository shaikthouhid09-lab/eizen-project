# Task 2: Docker Compose Setup

Quick start guide for local development with Docker Compose.

## Overview

This setup runs a Flask application behind an Nginx reverse proxy, both in Docker containers with full request logging.

**Features:**
- Flask app (internal, port 5000)
- Nginx reverse proxy (public, port 80)
- Request logging to `nginx/logs/access.log`
- Docker network isolation

## Quick Start

```bash
# Build and start
docker-compose up --build

# Access application
curl http://localhost
# Expected output: {"status":"ok","time":<timestamp>}

# View logs
tail -f nginx/logs/access.log
```

## Verify Setup

- Flask NOT exposed: `curl http://localhost:5000` should fail
- Nginx is reverse proxy: `curl http://localhost` should work

## Stop Services

```bash
docker-compose down
```

## Files

- `Dockerfile` - Flask application container
- `nginx.Dockerfile` - Nginx reverse proxy container
- `docker-compose.yml` - Service orchestration
- `nginx.conf` & `default.conf` - Nginx configuration
- `minimal-flask-example/` - Flask application source

---

For detailed information, see the main [README.md](../README.md)
