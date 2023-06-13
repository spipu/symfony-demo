<?php

declare(strict_types=1);

namespace App\WidgetSource;

use Spipu\DashboardBundle\Entity\Source as Source;

class TaskCount extends AbstractSource
{
    public function getDefinition(): Source\SourceSql
    {
        return (new Source\SourceSql("task-count", 'spipu_process_task'));
    }
}
