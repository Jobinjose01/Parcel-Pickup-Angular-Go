function RsCustomEvent ( event, message ) {
    params = { bubbles: false, cancelable: false, detail: message };
    var evt = document.createEvent( 'CustomEvent' );
    evt.initCustomEvent( event, params.bubbles, params.cancelable, params.detail );
    return evt;
}
var socket = io('localhost:3000');
socket.on("parcel-channel", function (message) {
    //console.log(message)
    window.dispatchEvent(RsCustomEvent('socketEventListen',message));

});