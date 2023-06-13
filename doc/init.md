# Init


## Init a new project

Create a new empty git project.

Copy the `architecture` folder.

Modify the project name (it must contain only chars, no minus or underscore) in the `architecture/conf/env.sh` file.

Create a new symfony 5 project with symfony cli

Create the dev environment:

```bash
./architecture/create-xxx.sh
```

## Install the Spipu Bundles

```bash
ssh delivery@symfonydemo.lxc
cd /var/www/symfonydemo/website

composer update
composer require spipu/core-bundle
composer require spipu/ui-bundle
composer require spipu/configuration-bundle
composer require spipu/user-bundle
```

## Move the app folder

Move all the files under `./src/` in a new `./src/App/` folder.

Modify the `getProjectDir` method of the `./src/App/Kernel.php` file:

```php
    public function getProjectDir(): string
    {
        return \dirname(\dirname(__DIR__));
    }
```

Modify the `autoload.psr-4` config in the `./composer.json` file :

```json
{
    "autoload": {
        "psr-4": {
            "App\\": "src/App/"
        }
    }
}
```

Modify the path `.../src/...` to `.../src/App/...`  in the following files:

* 1x in `./config/packages/doctrine.yaml`
* 1x in `./config/packages/doctrine_migrations.yaml`
* 1x in `./config/routes/annotations.yaml`
* 3x in `./config/services.yaml`

Launch the following command

```bash
ssh delivery@symfonydemo.lxc
cd /var/www/symfonydemo/website

../architecture/scripts/update.sh
```

## Container Strict Mode

Add the following line at the beginning of the `App/Kernel::configureContainer` method:

```php
    $container->setParameter('container.autowiring.strict_mode', true);
```

## Disable SwitftMailer Memory Pool

Comment the `spool memory` line in the file `./config/packages/swiftmailer.yaml`.

## Disable Automatic Public Services

Add the following line in the `services._defaults` part of the file `./config/services.yaml`

```yaml
services:
    _defaults:
        public: false       # Allows optimizing the container by removing unused services
```

## Configuration Bundle

Create the file `./config/packages/spipu_configuration.yaml` with the following content:

```yaml
imports:
- { resource: "@SpipuConfigurationBundle/Resources/config/spipu_configuration.yaml" }

spipu_configuration:
    app.website.name:
        type:     string
        required: true
        default:  "Website"
```

Create the file `./config/routes.yaml` with the following content:

```yaml
spipu_configuration:
  resource: '@SpipuConfigurationBundle/Resources/config/routes.yaml'
```

## User Bundle

Add the following content in the file `./config/routes.yaml`:

```yaml
spipu_user:
  resource: '@SpipuUserBundle/Resources/config/routes.yaml'
```

Put the following content in the file `./config/packages/security.yaml`

```yaml
security:
    encoders:
        Spipu\UserBundle\Entity\User:
            algorithm: auto

    providers:
        spipu_users:
            entity:
                class: Spipu\UserBundle\Entity\User

    firewalls:
        dev:
            pattern: ^/(_(profiler|wdt)|css|images|js)/
            security: false

        main:
            pattern:      ^/
            anonymous:    true
            provider:     spipu_users
            user_checker: Spipu\UserBundle\Security\UserChecker
            form_login:
                remember_me: true
                login_path: spipu_user_security_login
                check_path: spipu_user_security_login
                csrf_token_generator: security.csrf.token_manager
                default_target_path: app_home
            remember_me:
                secret: "%kernel.secret%"
                name: op_user_remember
                lifetime: 31536000 # 1 year
                httponly: false
            logout:
                path: spipu_user_security_logout
                target: app_home

    access_control:
        # Login & Logout
        - { path: ^/login,               roles: IS_AUTHENTICATED_ANONYMOUSLY }
        - { path: ^/logout,              roles: IS_AUTHENTICATED_ANONYMOUSLY }
        # Main
        - { path: ^/,                    roles: IS_AUTHENTICATED_ANONYMOUSLY }
```

## UI Bundle

Put the following content in the file `./templates/base.html.twig`

```twig
{% extends '@SpipuUi/base.html.twig' %}

{% block header_title %}{{ 'app.website.name'|get_config }}{% endblock %}

{% block main_class %}container{% endblock %}

{% block body %}{% endblock %}

{% block footer %}
    &copy; {{ "now"|date("Y") }} - {{ 'app.website.name'|get_config }} Website
{% endblock %}
```

Put the following content in the file `./templates/base_email.html.twig`

```twig
{% extends '@SpipuUi/base_email.html.twig' %}

{% block title %}{{ 'app.website.name'|get_config }}{% endblock %}

{% block body %}{% endblock %}
```

Put the following content in the file `./templates/main/home.html.twig`

```twig
{% extends 'base.html.twig' %}

{% set menuCurrentItem="home" %}

{% block header_title %}{{  parent() }} - Home{% endblock %}

{% block main_title %}HomePage{% endblock %}

{% block body %}
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    My Homepage
                </div>
                <div class="card-body">
                    This is a homepage test
                </div>
                <div class="card-footer">
                    Super Footer
                </div>
            </div>
        </div>
    </div>
{% endblock body %}
```

Put the following content in the file `./src/App/Controller/MainController.php`

```php
<?php
declare(strict_types = 1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

/**
 * Class MainController
 * @Route("/")
 */
class MainController extends AbstractController
{
    /**
     * @Route("/", name="app_home", methods="GET")
     * @return Response
     */
    public function home(): Response
    {
        return $this->render('main/home.html.twig');
    }
}
```

Put the following content in the file `./src/App/Service/MenuDefinition.php`

```php
<?php
declare(strict_types = 1);

namespace App\Service;

use Spipu\ConfigurationBundle\Service\Manager as ConfigurationManager;
use Spipu\UiBundle\Entity\Menu\Item;
use Spipu\UiBundle\Service\Menu\DefinitionInterface;

class MenuDefinition implements DefinitionInterface
{
    /**
     * @var Item
     */
    private $mainItem;

    /**
     * @var ConfigurationManager
     */
    private $configurationManager;

    /**
     * MenuDefinition constructor.
     * @param ConfigurationManager $configurationManager
     */
    public function __construct(ConfigurationManager $configurationManager)
    {
        $this->configurationManager = $configurationManager;
    }

    /**
     * @return void
     */
    private function build(): void
    {
        $this->mainItem = new Item($this->configurationManager->get('app.website.name'), '', 'app_home');

        $this->mainItem
            ->addChild('spipu.ui.page.home', 'home', 'app_home')
                ->getParentItem()
            ->addChild('spipu.ui.page.admin')
                ->addChild(
                    'spipu.configuration.page.admin.list',
                    'spipu-configuration-admin',
                    'spipu_configuration_admin_list'
                )
                    ->setACL(true, 'ROLE_ADMIN_MANAGE_CONFIGURATION_SHOW')
                    ->getParentItem()
                ->addChild('spipu.user.page.admin.list', 'spipu-user-admin', 'spipu_user_admin_list')
                    ->setAcl(true, 'ROLE_ADMIN_MANAGE_USER_SHOW')
                    ->getParentItem()
                ->getParentItem()
            ->addChild('spipu.user.page.profile.show', 'spipu-user-profile', 'spipu_user_profile_show')
                ->setACL(true)
                ->setIcon('user')
                ->getParentItem()
            ->addChild('spipu.user.page.security.log_in', 'spipu-user-login', 'spipu_user_security_login')
                ->setACL(false)
                ->setIcon('sign-in-alt')
                ->getParentItem()
            ->addChild('spipu.user.page.security.log_out', 'spipu-user-logout', 'spipu_user_security_logout')
                ->setACL(true)
                ->setIcon('sign-out-alt')
                ->getParentItem()
        ;
    }

    /**
     * @return Item
     */
    public function getDefinition(): Item
    {
        if (!$this->mainItem) {
            $this->build();
        }

        return $this->mainItem;
    }
}
```

Add the following content at the end of the file `./config/services.yaml`

```yaml
services:
    ...
    
    # App Menu Definition
    spipu.ui.service.menu_definition:
        class: 'App\Service\MenuDefinition'
        arguments:
            - '@Spipu\ConfigurationBundle\Service\Manager'
```


Modify the `scripts.auto-scripts` config in the `./composer.json` file by adding the Spipu Assets install command :

```json
{
    "scripts": {
        "auto-scripts": {
            ...
            "spipu:assets:install %PUBLIC_DIR%": "symfony-cmd",
            ...
        }
    }
}
```

## Finished !

Launch the following command

```bash
ssh delivery@symfonydemo.lxc
cd /var/www/symfonydemo/website

../architecture/scripts/update.sh
sudo -u www-data ./bin/console spipu:fixtures:load
```
