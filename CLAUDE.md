# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Symfony 7.4 demo application (PHP >= 8.3) for testing Spipu Bundles (v5.x). The main application lives in `website/`, with deployment tooling in `architecture/` and code quality tooling in `quality/`.

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

# Run full code quality analysis (from repo root)
./quality/analyze.sh

# Run PHPCS only
cd website && ./vendor/bin/phpcs --standard=.phpcs.xml src/

# Run architecture validation (deptrac)
./quality/deptrac.sh
```

Full installation script (for Docker/LXD environments): `./architecture/scripts/install.sh`

Docker environment: `./architecture/create-docker.sh` to build.

**To validate on the container:**
```bash
ssh delivery@symfonydemo.lxc
~/install.sh
```

There are no automated tests — `website/tests/` exists but is empty.

## Code Style

- PSR-12 standard with additional rules (see `website/.phpcs.xml`)
- No global functions (Squiz.Functions.GlobalFunction enforced)
- No `sizeof`/`count` in loop conditions
- PHP 8 attributes for Doctrine mapping (not annotations)
- PHPMD enforces minimum 3-char variable names (exception: `id`), maximum 30-char
- `quality/analyze.sh` uses `.phpqa.yml` which enforces **0 errors** for phpcs, phpmd, phpcpd, and parallel-lint

## Frontend Libraries

- **Bootstrap 5.3** — use `data-bs-*` attributes, `me-/ms-/pe-/ps-*` spacing, `text-start/end`, `float-start/end`, `text-bg-*` badges, `form-select`, `fw-bold`, `mb-3` (not `form-group`), `w-100` (not `btn-block`)
- **jQuery 4.0** — no `$.proxy()`, `$.grep()` ; use `.bind()` and `Array.filter()`
- **FontAwesome 7** — use `fa-solid`/`fa-regular`/`fa-brands` prefixes (not `fas`/`far`/`fab`/`fa`). Icon names: `pen-to-square`, `xmark`, `right-to-bracket`, `right-from-bracket`, `magnifying-glass`, `gear`, `trash-can`, `rotate`, `triangle-exclamation`. In PHP `setIcon()` calls, the name is passed without the `fa-` prefix.

## Architecture

**Namespace:** `App\` mapped to `website/src/App/`

**Layer dependency rules** (enforced by deptrac in `.depfile.mvc.yaml`):
- Controllers → Entities, Repositories, Services, Ui, Forms, Validators
- Services → Entities, Repositories, Forms
- Repositories → Entities only
- Entities → Validators, FormOptions only
- Commands → Entities, Repositories, Services, FormOptions
- Steps → Services, Entities, Repositories, FormOptions
- Ui → Entities, Repositories, Services, FormOptions
- Forms → Entities, Repositories, Services, FormOptions

**Spipu Bundle integration:** The app extends several Spipu bundles (Core, UI, Configuration, User, Process, Dashboard):
- Controllers extend `Spipu\CoreBundle\Controller\AbstractController` (not Symfony's)
- The User entity extends `Spipu\UserBundle\Entity\AbstractUser`
- Templates extend `@SpipuUi/base.html.twig`
- Menu is defined in `App\Service\MenuDefinition` implementing `DefinitionInterface`
- Dashboard widget sources in `src/App/WidgetSource/` are tagged with `spipu.widget.source` (auto-tagged via services.yaml resource pattern)
- Dashboard UI definitions implement `DashboardDefinitionInterface` (see `App\Ui\AdminDashboard`)
- Spipu configuration values are accessed in Twig via `{{ 'app.website.name'|get_config }}`
- Process examples defined in `config/process/` as YAML (see `test_hello.yaml` for structure)

**Configuration:** App parameters defined in `config/app_default_configuration.yaml` using `APP_SETTINGS_*` env vars, overridable via `/etc/symfonydemo/symfony.yaml`. Default database is SQLite (for dev/test); MariaDB/MySQL in deployed environments. Redis optionally used for cache and sessions.

**Quality tooling notes:**
- `website/patches/` contains a patch for `consolidation/robo` (PHPQA dependency) required for Symfony Console 7.4 compatibility — do not remove until Robo releases a fix natively
- Deptrac config (`.depfile.mvc.yaml`) uses the `deptrac:` root key and `type: classLike` / `value:` collector syntax (new format since deptrac v2)
