import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TranslateModule } from '@ngx-translate/core';
import { FlexLayoutModule } from '@angular/flex-layout';

import { SharedModule } from '@shared';
import { MaterialModule } from '@app/material.module';
import { BikerHomeRoutingModule } from './bikerhome-routing.module';
import { BikerHomeComponent } from './bikerhome.component';

@NgModule({
  imports: [CommonModule, TranslateModule, SharedModule, FlexLayoutModule, MaterialModule, BikerHomeRoutingModule ],
  declarations: [BikerHomeComponent],
})
export class BikerHomeModule {}
