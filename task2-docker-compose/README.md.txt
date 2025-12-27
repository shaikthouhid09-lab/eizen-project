# Flask Application with Nginx Reverse Proxy (Docker Compose)

## Overview
This project demonstrates running a Flask application locally using Docker Compose, with **Nginx acting as a reverse proxy** in front of the application.

The Flask application container is **not exposed directly**. All external traffic is routed through the Nginx container, which also **logs every request**, as required.

This setup is based on the repository:
https://github.com/matdoering/minimal-flaskexample

---

## Architecture

- **Flask App**
  - Runs internally on port `5000`
  - Not exposed to the host
  - Accessible only via Docker network

- **Nginx**
  - Exposed on port `80`
  - Proxies all incoming requests to the Flask app
  - Logs requests to `/var/log/nginx`

---

## Project Structure

.
├── Dockerfile # Flask application Dockerfile
├── docker-compose.yml # Docker Compose configuration
├── nginx.Dockerfile # Nginx Dockerfile
├── nginx.conf # Main Nginx configuration
├── default.conf # Nginx server (proxy) configuration
├── nginx/
│ └── logs/ # Nginx access and error logs
└── README.md


---

## Prerequisites

- Docker
- Docker Compose
- Docker Desktop (for Windows/macOS users)

---

## How to Run

From the project root directory:

```bash
docker-compose down
docker-compose build
docker-compose up

Accessing the Application

Open your browser and go to:

http://localhost


You should receive a JSON response similar to:

{"status":"ok","time":<timestamp>}

Validation Checks
Flask is NOT exposed

The following should not work:

http://localhost:5000

Nginx logs requests

Nginx logs are available on the host at:

nginx/logs/access.log
nginx/logs/error.log

Key Points

Flask runs only inside the Docker network

Nginx is the single entry point

Requests are proxied and logged by Nginx

Clean separation of concerns

Matches real-world production patterns

Notes

Flask runs using the built-in development server, which is acceptable for this assignment.

SSL (HTTPS) is intentionally not configured to keep the setup minimal and focused on the task requirements.

Conclusion

This setup fulfills the requirement to:

Build and run the service locally using Docker Compose

Prevent direct exposure of the application container

Use Nginx as a reverse proxy and request logger


---

## What to do next

1. Save this as `README.md`
2. Commit and push:

```bash
git add README.md
git commit -m "Add README explaining docker-compose nginx proxy setup"
git push
