import { Component, OnInit, Inject } from '@angular/core';
import { finalize, first } from 'rxjs/operators';
import { Observable , fromEvent} from 'rxjs';
import { BikerParcelService } from './bikerparcel.service';
import jwt_decode from "jwt-decode";
import { Credentials, CredentialsService } from '../auth/credentials.service';
import { Router, NavigationEnd } from '@angular/router';
import {MatDialog, MatDialogConfig, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {DateDialogComponent} from "../date-dialog/date-dialog.component";
import {MatSnackBar} from '@angular/material/snack-bar';
import { io, Socket } from 'socket.io-client';
import { environment } from '@env/environment';

@Component({
  selector: 'app-home',
  templateUrl: './bikerhome.component.html',
  styleUrls: ['./bikerhome.component.scss'],
  providers: []
})



export class BikerHomeComponent implements OnInit {

  result : any;
  socketdata : any;
  isLoading = false;
  errorMessage : string = "";
  picked_date: string = "";
  dataSource :any;
  displayedColumns:any;


  constructor(private parcelService: BikerParcelService,
   private credentialsService: CredentialsService,
   public dialog: MatDialog,
   private snackbar: MatSnackBar,
   private router : Router,
   ) {

      this.displayedColumns  = ['order_id', 'pickup_address', 'delivery_address', 'created_at','pickup_time','delivery_time','status','parcel_order_id'];
      //this.loadParcelList();
    }




  ngOnInit() {
      
      this.loadParcelList();

      fromEvent(window, 'socketEventListen').subscribe((data) =>{
          this.socketdata = data;
          //console.log(this.socketdata.detail);

          if(this.checkDataStream(this.socketdata.detail)){
            this.snackbarMessage(this.socketdata.detail.message);
            this.loadParcelList();
          }
      });

      

  }

  checkDataStream(data :any):boolean {
 
    let acces_token = this.credentialsService.getToken();
    let decodedHeader : any = jwt_decode(acces_token);

     //check the routes for listing only
     if(this.router.url == '/create'){
       return false
     }

      //For all bikers new list available
     if(data.message_type == 'create' && decodedHeader.groups == 3){
         return true;
     }

     //For Pickup only
     if(data.message_type == 'pickup'){

         //For all bikers the list get updated
         if(decodedHeader.groups == 3){

           return true;
         }

         // For senders only their own list get updated
         if(decodedHeader.groups == 2 && decodedHeader.user_id == data.data.sender_id){

           return true;

         }


     }

     //For Delivery
     if(data.message_type == 'delivery'){

         // For senders only their own list get updated
         if(decodedHeader.groups == 2 && decodedHeader.user_id == data.data.sender_id){

           return true;

         }
         
         // For Bikers only thier own pickup needs to update to them
         if(data.delivered_user_id == decodedHeader.user_id && decodedHeader.groups == 3){
           return true;
         }
     }

     
    return false;
  }

  loadParcelList(){

    this.isLoading = true;
    
    let acces_token = this.credentialsService.getToken();
    let decodedHeader : any = jwt_decode(acces_token);

   if(decodedHeader.groups == 3){

      

      const resultdata = this.parcelService.getBikersList();
      resultdata
      .pipe(first())
      .subscribe({
        next: data => {

            this.dataSource =  data;
        },
        error: error => {
            this.errorMessage = error.message;
            
        }
    })
    }else{
      this.dataSource =  [];
    }

  }


  initPickup(parcel_order_id: string){

     const dialogRef = this.dialog.open(DateDialogComponent, {
      width: '300px',
      data: {label : "Pickup",action : "Please enter your pickup datetime"}
    });

    dialogRef.afterClosed().subscribe(result => {
      
      if(result != '' && result !== undefined){
        
        this.picked_date = this.formatMyDate(result);
        //console.log(this.picked_date);
          this.isLoading = true;
          const resultdata = this.parcelService.updatePickup(parcel_order_id, this.picked_date);
              resultdata
              .pipe(first())
              .subscribe(
                data => {
                    this.result = data;
                    //console.log(this.result.status)
                    if(this.result.status == 1){
                      this.snackbarMessage(this.result.message);
                      //this.loadParcelList();                

                    }else{
                      this.snackbarMessage(this.result.message);
                    }
                },
                 (error) => {
                    this.snackbarMessage("something went wrong !");
                  }
            );
      }

        

    });

       

  }

  formatMyDate(date_value : any){

    let cur_date = date_value.getDate();
    let cur_month : any = parseInt(date_value.getMonth()) + 1;
    let cur_year = date_value.getFullYear();
    let cur_hours = date_value.getHours();
    let cur_min = date_value.getMinutes();
    let cur_sec = date_value.getSeconds();

    cur_date = ("0"+cur_date).slice(-2);
    cur_month = ("0"+cur_month).slice(-2);
    cur_hours = ("0"+cur_hours).slice(-2);
    cur_min = ("0"+cur_min).slice(-2);
    cur_sec = ("0"+cur_sec).slice(-2);

    let final_date :string = cur_date+"-"+cur_month+"-"+cur_year+" "+cur_hours+":"+cur_min+":"+cur_sec;
    return final_date;
  }

  initDeliver(parcel_order_id: string){

      const dialogRef = this.dialog.open(DateDialogComponent, {
      width: '300px',
      data: {label : "Delivery",action : "Please enter your delivery datetime"}
    });

    dialogRef.afterClosed().subscribe(result => {
      
      if(result != '' && result !== undefined){

        this.picked_date = this.formatMyDate(result);
        //console.log(this.picked_date);
        
          this.isLoading = true;
          const resultdata = this.parcelService.updateDelivery(parcel_order_id, this.picked_date);
              resultdata
              .pipe(first())
              .subscribe(
                data => {
                    this.result = data;
                     if(this.result.status == 1){
                      this.snackbarMessage(this.result.message);
                      this.loadParcelList();                

                    }else{
                      this.snackbarMessage(this.result.message);
                    }
                },
                 (error) => {
                    this.snackbarMessage("something went wrong !");
                  }
            );
      }

        

    });

  }

  snackbarMessage(message : string){
    this.snackbar.open(message, 'Close', {
            duration: 3000
      });
  }
  

}



