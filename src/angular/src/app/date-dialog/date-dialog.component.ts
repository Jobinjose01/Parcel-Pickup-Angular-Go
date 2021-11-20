import {Component, Inject, OnInit, ViewEncapsulation} from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import {FormBuilder, Validators, FormGroup} from "@angular/forms";



@Component({
    selector: 'date-dialog',
    templateUrl: './date-dialog.component.html',
    styleUrls: ['./date-dialog.component.css']
})
export class DateDialogComponent implements OnInit {


    datepicker : string = "";
    constructor(
        private fb: FormBuilder,
        private dialogRef: MatDialogRef<DateDialogComponent>,
        @Inject(MAT_DIALOG_DATA) public data: any ) {

   

    }

    ngOnInit() {

    }
    

    closeDailog(){
       
        this.dialogRef.close();
    }

}
