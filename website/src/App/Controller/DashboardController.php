<?php

declare(strict_types=1);

namespace App\Controller;

use App\Ui\AdminDashboard;
use Spipu\DashboardBundle\Service\DashboardControllerService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class DashboardController extends AbstractController
{
    #[Route(path: '/dashboard/{action}/{id?}', name: 'app_dashboard')]
    public function main(
        DashboardControllerService $dashboardControllerService,
        AdminDashboard $dashboard,
        string $action = '',
        ?int $id = null
    ): Response {
        return $dashboardControllerService->dispatch($dashboard, 'app_dashboard', $action, $id);
    }
}
