import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TranslateModule } from '@ngx-translate/core';
import { FlexLayoutModule } from '@angular/flex-layout';

import { ReactiveFormsModule } from '@angular/forms';
import { SharedModule } from '@shared';
import { MaterialModule } from '@app/material.module';
import { CreateParcelRoutingModule } from './createparcel-routing.module';
import { CreateParcelComponent } from './createparcel.component';

@NgModule({
  imports: [CommonModule, TranslateModule, SharedModule, ReactiveFormsModule,  FlexLayoutModule, MaterialModule, CreateParcelRoutingModule],
  declarations: [CreateParcelComponent],
})
export class CreateParcelModule {}
