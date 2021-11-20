import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { finalize, first } from 'rxjs/operators';

import { environment } from '@env/environment';
import { Logger, UntilDestroy, untilDestroyed } from '@shared';
import { ParcelService } from '../home/parcel.service';
import {MatSnackBar} from '@angular/material/snack-bar';

const log = new Logger('Login');

@Component({
  selector: 'app-about',
  templateUrl: './createparcel.component.html',
  styleUrls: ['./createparcel.component.scss'],
})
export class CreateParcelComponent implements OnInit {
  version: string | null = environment.version;

  error: string | undefined;
  pickupForm!: FormGroup;
  isLoading = false;
  resultdata: any;
  errormsg: string | undefined;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private formBuilder: FormBuilder,
    private parcelService: ParcelService,
    private snackbar: MatSnackBar,
    
    ) {
    this.createForm();
  }

  ngOnInit() {}



  pickup(){

    this.isLoading = true;
    const parceldata = this.parcelService.createparcel(this.pickupForm.value);
    parceldata
      .pipe(first())
      .subscribe(
        data => {
           this.resultdata = data;           
           this.isLoading = false;

          
          if (this.resultdata.id > 0) {
              
              this.snackbarMessage("Pickup created Successfully!");
              
          }else{
            this.snackbarMessage("Pickup Creation Failed!");
          }
        },
        (error) => {
          log.debug(`Login error: ${error}`);
          this.error = error;
        }
      );

      this.pickupForm.reset();

  }


  private createForm() {
    this.pickupForm = this.formBuilder.group({
      pickup_address: ['', Validators.required],
      delivery_address: ['', Validators.required]

    });
  }


  snackbarMessage(message : string){
    this.snackbar.open(message, 'Close', {
            duration: 3000
      });
  }
}
