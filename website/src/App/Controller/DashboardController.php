<?php

declare(strict_types=1);

namespace App\Controller;

use App\Ui\AdminDashboard;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Security;
use Spipu\DashboardBundle\Exception\WidgetException;
use Spipu\DashboardBundle\Service\DashboardControllerService;
use Spipu\UiBundle\Exception\UiException;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

/**
 * @Security("is_granted('ROLE_ADMIN')")
 */
class DashboardController extends AbstractController
{
    /**
     * @Route("/dashboard/{action}/{id?}", name="app_dashboard")
     * @param DashboardControllerService $dashboardControllerService
     * @param AdminDashboard $dashboard
     * @param string $action
     * @param int|null $id
     * @return Response
     * @throws WidgetException
     * @throws UiException
     */
    public function main(
        DashboardControllerService $dashboardControllerService,
        AdminDashboard $dashboard,
        string $action = '',
        ?int $id = null
    ): Response {
        return $dashboardControllerService->dispatch($dashboard, 'app_dashboard', $action, $id);
    }
}
