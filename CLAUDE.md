# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Symfony 6.4 demo application (PHP >= 8.1) for testing Spipu Bundles. The main application lives in `website/`, with deployment tooling in `architecture/` and code quality tooling in `quality/`.

## Common Commands

All commands run from the `website/` directory:

```bash
# Install dependencies
composer install

# Clear cache
./bin/console cache:clear

# Install assets
./bin/console assets:install --symlink --relative
./bin/console spipu:assets:install

# Update database schema (used instead of migrations)
./bin/console doctrine:schema:update --force --dump-sql

# Load fixtures
./bin/console spipu:fixtures:load

# Run code quality analysis (from repo root)
./quality/analyze.sh

# Run PHPCS only
cd website && ./vendor/bin/phpcs --standard=.phpcs.xml src/

# Run architecture validation (deptrac)
cd website && ./vendor/bin/deptrac analyze --config-file=.depfile.mvc.yaml
```

Full installation script (for Docker/LXD environments): `./architecture/scripts/install.sh`

Docker environment: `./architecture/create-docker.sh` to build.

## Code Style

- PSR-12 standard with additional rules (see `website/.phpcs.xml`)
- No global functions (Squiz.Functions.GlobalFunction enforced)
- No `sizeof`/`count` in loop conditions
- PHP 8 attributes for Doctrine mapping (not annotations)
- PHPMD enforces minimum 3-char variable names (exception: `id`), max 30-char

## Architecture

**Namespace:** `App\` mapped to `website/src/App/`

**Layer dependency rules** (enforced by deptrac in `.depfile.mvc.yaml`):
- Controllers → Entities, Repositories, Services, Ui, Forms, Validators
- Services → Entities, Repositories, Forms
- Repositories → Entities only
- Entities → Validators, FormOptions only
- Commands → Entities, Repositories, Services, FormOptions
- Steps → Services, Entities, Repositories, FormOptions

**Spipu Bundle integration:** The app extends several Spipu bundles (Core, UI, Configuration, User, Process, Dashboard). The User entity extends `Spipu\UserBundle\Entity\AbstractUser`. Templates extend `@SpipuUi/base.html.twig`. Menu is defined in `App\Service\MenuDefinition`. Dashboard widget sources in `src/App/WidgetSource/` are tagged with `spipu.widget.source` in `config/services.yaml`.

**Configuration:** App parameters defined in `config/app_default_configuration.yaml` using `APP_SETTINGS_*` env vars, overridable via `/etc/symfonydemo/symfony.yaml`. Database is MariaDB. Redis is used for cache (port 6379) and sessions (port 6380).