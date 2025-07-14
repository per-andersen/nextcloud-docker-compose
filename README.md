# Nextcloud Docker Compose Deployment

This repository contains a Docker Compose configuration for deploying Nextcloud with MariaDB and custom configurations including cron, FFmpeg, and optionally PDLib support.

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

4. (Optionally) Enabling PDLib
   - Uncomment the lines between lines 30 and 64 in the Dockerfile. PDLib is off by default as it is costly to include. Only enable it if needed.

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

## Nextcloud Configuration (config.php)

### Using Environment Variables

The Nextcloud configuration can be managed through environment variables in the `docker-compose.yml` file. Some important variables already included:

```yaml
environment:
  - OVERWRITEPROTOCOL=https
  - OVERWRITECLIURL=https://<YOUR-NEXTCLOUD-DOMAIN>
```

Additional common configuration options you can add:

```yaml
environment:
  - NEXTCLOUD_TRUSTED_DOMAINS=your-domain.com
  - TRUSTED_PROXIES=172.16.0.0/12
  - REDIS_HOST=redis
  - SMTP_HOST=smtp.example.com
  - SMTP_PORT=587
  - SMTP_SECURE=tls
  - MAIL_FROM_ADDRESS=nextcloud
  - MAIL_DOMAIN=example.com
```

### Direct Configuration

To modify the config.php file directly:

1. Access the container:
```bash
docker compose exec app bash
```

2. Edit the configuration file:
```bash
vi /var/www/html/config/config.php
```

Common configurations to consider:
```php
$CONFIG = array (
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => 'your-domain.com',
  ),
  'trusted_proxies' => ['172.16.0.0/12'],
  'overwrite.cli.url' => 'https://your-domain.com',
  'overwriteprotocol' => 'https',
  'mail_smtpmode' => 'smtp',
  'mail_smtphost' => 'smtp.example.com',
  'mail_smtpport' => '587',
);
```

Remember to restart the Nextcloud container after making changes:
```bash
docker compose restart app
```

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
