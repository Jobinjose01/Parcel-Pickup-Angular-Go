import { NgModule } from '@angular/core';
import { Routes, RouterModule, PreloadAllModules } from '@angular/router';
import { Shell } from '@app/shell/shell.service';

const routes: Routes = [
  Shell.childRoutes([{ path: 'create', loadChildren: () => import('./createparcel/createparcel.module').then((m) => m.CreateParcelModule) },
    { path: 'bikerhome', loadChildren: () => import('./bikerhome/bikerhome.module').then((m) => m.BikerHomeModule) }
    ]),
  // Fallback when no prior route is matched
  { path: '**', redirectTo: '', pathMatch: 'full' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { preloadingStrategy: PreloadAllModules })],
  exports: [RouterModule],
  providers: [],
})
export class AppRoutingModule {}
