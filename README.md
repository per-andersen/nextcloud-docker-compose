# Nextcloud Docker Compose Deployment

This repository contains a Docker Compose configuration for deploying Nextcloud with MariaDB and custom configurations including cron, FFmpeg, and PDLib support.

## Prerequisites

- Docker
- Docker Compose
- Git

## Configuration

Before deploying, you need to modify several configuration values in the `docker-compose.yml` file:

1. Database configuration:
   - Replace `<CHANGE-THIS-1>` with a secure password for the MariaDB root user
   - Replace `<CHANGE-THIS-2>` with a secure password for the Nextcloud database user

2. Volume mappings:
   - Replace `<YOUR-MYSQL-DIRECTORY>` with the path where you want to store your MariaDB data
   - Replace `<YOUR-HTML-DIRECTORY>` with the path where you want to store your Nextcloud data

3. Domain configuration:
   - Replace `<YOUR-NEXTCLOUD-DOMAIN>` with your actual domain name (e.g., `nextcloud-example.com`)

## Building the Custom Image

The deployment uses a custom Docker image that includes cron, FFmpeg, and PDLib support. To build the image:

```bash
cd nextcloud-dockerfile
docker build -t nextcloud-cron-ffmpeg-pdlib:latest .
```

## Deployment

1. After configuring all the variables and building the custom image, start the deployment:

```bash
docker compose up -d
```

2. The Nextcloud instance will be available on port 9196. You can access it at:
   - `http://localhost:9196` (if accessing locally)
   - `https://<YOUR-NEXTCLOUD-DOMAIN>` (if configured with a domain and HTTPS)

## Configuration Details

- MariaDB version: 11.4
- PHP Memory Limit: 4096M
- PHP Upload Limit: 4096M
- Database Isolation Level: READ-COMMITTED
- Protocol: HTTPS (configured by default)

## Maintenance

### Updating

To update the deployment:

```bash
docker compose pull
docker compose up -d
```

### Backing Up

Important directories to backup:
- Database: `<YOUR-MYSQL-DIRECTORY>/mysql`
- Nextcloud data: `<YOUR-HTML-DIRECTORY>/html`

## Troubleshooting

If you encounter permission issues with the volumes, ensure that the directories exist and have the correct permissions before starting the containers.

For database connection issues, verify that:
1. The passwords match in both the database and app service configurations
2. The database service is running (`docker compose ps`)
3. The database is properly initialized

## Security Notes

- Always change the default passwords in the docker-compose.yml file
- Use strong, unique passwords
- Consider using Docker secrets for production deployments
- Ensure proper firewall rules are in place
- Regular backups are recommended
