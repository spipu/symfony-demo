<?php

declare(strict_types=1);

namespace App\WidgetSource;

use Spipu\DashboardBundle\Entity\Source as Source;

class UserNb extends AbstractSource
{
    public function getDefinition(): Source\SourceSql
    {
        return (new Source\SourceSql("user-count", 'spipu_user'))
            ->setDateField(null);
    }
}
