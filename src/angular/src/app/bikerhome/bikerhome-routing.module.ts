import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { marker } from '@biesbjerg/ngx-translate-extract-marker';

import { BikerHomeComponent } from './bikerhome.component';
import { Shell } from '@app/shell/shell.service';

const routes: Routes = [
  Shell.childRoutes([
    { path: '', redirectTo: '/bikerhome', pathMatch: 'full' },
    { path: 'bikerhome', component: BikerHomeComponent, data: { title: marker('Bikers Home') } },
  ]),
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
  providers: [],
})
export class BikerHomeRoutingModule {}
