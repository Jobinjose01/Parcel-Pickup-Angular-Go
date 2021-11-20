import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, catchError } from 'rxjs/operators';


import { environment } from '@env/environment';

export interface RandomQuoteContext {
  // The quote's category: 'dev', 'explicit'...
  category: string;
}

@Injectable({
  providedIn: 'root',
})
export class BikerParcelService {

  result : any ;


  constructor(private httpClient: HttpClient ) {

  }


  getBikersList(){
    
    return this.httpClient.get<any>(environment.serverUrl + 'parcel/bikerslist')
      .pipe(
      map(result => {

        return result;
      }
      ));
  }

  updatePickup(parcel_order_id : string, pickup_time : string){


    return this.httpClient
    .post<any>(environment.serverUrl + 'parcel/pickup', { parcel_order_id , pickup_time })
    .pipe(
      map(result => {
        
          return result;
      })
    );

  }

  updateDelivery(parcel_order_id : string, delivery_time : string){


    return this.httpClient
    .post<any>(environment.serverUrl + 'parcel/delivery', { parcel_order_id , delivery_time })
    .pipe(
      map(result => {
        
          return result;
      })
    );

  }

}
