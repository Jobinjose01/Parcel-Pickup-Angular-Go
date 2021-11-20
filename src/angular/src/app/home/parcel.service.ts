import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, catchError } from 'rxjs/operators';


import { environment } from '@env/environment';

export interface PickupContext {
  resultdata: any;
  pickup_address: string;
  delivery_address: string;

}


@Injectable({
  providedIn: 'root',
})
export class ParcelService {

  result : any ;
  resultdata: any;


  constructor(private httpClient: HttpClient ) {

  }



  getSendersList(){

    return this.httpClient.get<any>(environment.serverUrl + 'parcel/list')
      .pipe(
      map(result => {

        return result;
      }
      ));

  }

  getBikersList(){

    return this.httpClient.get<any>(environment.serverUrl + 'parcel/bikerslist')
      .pipe(
      map(result => {

        return result;
      }
      ));
  }

  createparcel(context: PickupContext){

    let pickup_address = context.pickup_address;
    let delivery_address = context.delivery_address;
    return this.httpClient
    .post<any>(environment.serverUrl + 'parcel/create', { pickup_address , delivery_address })
    .pipe(
      map(result => {
        return result;
       
      })
    );
  }

}
