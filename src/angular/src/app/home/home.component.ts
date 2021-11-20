import { Component, OnInit } from '@angular/core';
import { finalize, first } from 'rxjs/operators';
import {MatSnackBar} from '@angular/material/snack-bar';
import { ParcelService } from './parcel.service';
import jwt_decode from "jwt-decode";
import { Credentials, CredentialsService } from '../auth/credentials.service';
import { Observable , fromEvent} from 'rxjs';
import { Router, NavigationEnd } from '@angular/router';


export interface parcelDetails {
  id:number;
  sender_id:number;
  order_id: string;
  pickup_address: string;
  delivery_address: string;
  created_at: string;
  updated_at: string;
  deleted_at: string;
  ParcelOrderDetails: [{

    id:number;
    biker_id:number;
    parcel_order_id:number;
    pickup_time:string;
    delivery_time:string;
    status:string;
    created_at:string;
    updated_at: string;
    deleted_at: string;
  }]
}




@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
})


export class HomeComponent implements OnInit {
  
  result : any;
  isLoading = false;
  errorMessage : string = "";
  socketdata : any;
  
  dataSource :any;
  displayedColumns:any;

  constructor(private parcelService: ParcelService,
   private credentialsService: CredentialsService,
   private snackbar : MatSnackBar,
   private router : Router,
   ) {

    this.displayedColumns  = ['order_id', 'pickup_address', 'delivery_address', 'created_at','pickup_time','delivery_time','status'];
  }

  ngOnInit() {

      this.loadParcelList();

      fromEvent(window, 'socketEventListen').subscribe((data) =>{
          this.socketdata = data;
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

    if(decodedHeader.groups == 2){

      

      const resultdata = this.parcelService.getSendersList();
      resultdata
      .pipe(first())
      .subscribe({
        next: data => {

            this.dataSource =  data;
        },
        error: error => {
            this.errorMessage = error.message;
            
        }
    });

    }else{

        this.router.navigate(['/bikerhome'], { replaceUrl: true });
        this.dataSource =  [];
       
    }
  }

  snackbarMessage(message : string){
    this.snackbar.open(message, 'Close', {
            duration: 3000
      });
  }
}
