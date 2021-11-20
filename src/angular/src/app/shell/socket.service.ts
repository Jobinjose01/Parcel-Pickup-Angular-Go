import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { io, Socket } from 'socket.io-client';
import { environment } from '@env/environment';

@Injectable()
export class SocketService {
  private socket: Socket;

  constructor() {
    this.socket = io(environment.socketUrl);

    this.socket.on("connect", () => {
      console.log("Status"+this.socket.connected); // true
    });

  }

  // EMITTER example
  sendMessage(msg: string) {
    this.socket.emit('sendMessage', { message: msg });
  }

  // HANDLER example
  onNewMessage() {
    return new Observable(observer => {
      this.socket.on('parcel-channel', msg => {
        observer.next(msg);
      });
    });
  }


}