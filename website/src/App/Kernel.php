<?php

/**
 * This file is a demo file for Spipu Bundles
 *
 * (c) Laurent Minguet
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace App;

use App\DependencyInjection\AppExtension;
use Symfony\Bundle\FrameworkBundle\Kernel\MicroKernelTrait;
use Symfony\Component\HttpKernel\Kernel as BaseKernel;

class Kernel extends BaseKernel
{
    use MicroKernelTrait;

    private ?string $projectDir = null;

    public function getProjectDir(): string
    {
        if (null === $this->projectDir) {
            $this->projectDir = dirname(__DIR__, 2);
        }

        return $this->projectDir;
    }
}
