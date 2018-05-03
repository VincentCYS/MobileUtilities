var workspace = require("ANYWorkspace");
var __rN = require("ReactNative");
module.exports=function(d,t){
    /* d=self, t=hooks */
    var k = workspace.value(d,d.__props.url) || "";
    var g = {
        method:{READ:"GET",CREATE:"POST",UPDATE:"PUT",DELETE:"DELETE"}[(d.__props.type||"GET").toUpperCase()],
        headers:{
            "Content-Type":{
                json:"application/json",
                querystring:"application/x-www-form-urlencoded"
            }[(d.__props.format||"querystring").toLowerCase()]
        }
    };
    if (0 < k.length) {
        var n=workspace.path(d);
        var l=n.length;
        var f=null;
        var m=d.__props.authMode||"Basic";
        var a=[workspace.value(d,d.__props.authU)||"",workspace.value(d,d.__props.authP)||""].filter(function(e){return e});
        0<a.length&&(g.headers.Authorization=m+" "+(1<a.length?Base64.encode(a.join(":")):a[0]));
        
        /* process form data */
        if((a=workspace.value(d,d.__props.formData)||"")&&0<a.length){
            if("application/json"==g.headers["Content-Type"]){
                m=null;
                try{m=JSON.parse(a)}catch(e){m=null}
                if(!m){
                    m={};a=a.split("&");for(var p in a){a[p]=a[p].split("=");var y=a[p].shift();a[p]=a[p].join("=");m[y]=a[p]}
                }
                a=JSON.stringify(m);
            }
            0<a.length&&(!/^wss?:\/\//i.test(k)&&/^(get|delete)$/i.test(g.method)?c+=(0<=c.indexOf("?")?"&":"?")+a:g.body=a)
        }
        
        /* websocket */
        if (/^wss?:\/\//i.test(k)) {
            var q=Base64.encode(k),r=function(){/^post$/i.test(g.method)?global.socks[q].connection.send(g.body):/^get$/i.test(g.method)&&(global.socks[q].listeners[d.__id]=function(e){for(;0<--l&&!f;)"undefined"!=typeof n[l].__props.setState&&(f=n[l].__props);var b=workspace.value(d,"${"+d.__props.alias+"}")||[];Array.isArray(b)||(b=[]);Array.isArray(e)?b=b.concat(e):b.push(e);workspace.store(b,d.__props.alias);f&&f.setState(f.state,function(){t.succeeded&&t.succeeded()})})};global.socks=global.socks||[];if("undefined"!=typeof global.socks[q]&&global.socks[q].connection)r();else{var h=new WebSocket(k);global.socks[q]={connection:null,listeners:{}};h.onopen=function(){h._key=q;global.socks[h._key].connection=h;r()};h.onmessage=function(e){var b=global.socks[h._key].listeners||{},a=null;try{a=JSON.parse(e.data)}catch(A){a={}}for(var d in b)b[d](a)};h.onclose=function(){"undefined"!=typeof global.socks[h._key]&&(global.socks[h._key].connection=null,delete global.socks[h._key])}}
        /* bluetooth */
        } else if(/^ble?:\/\//i.test(k)) {
            var u=new __rN.NativeEventEmitter(__rN.NativeModules.BleManager),v={},w=function(e){for(e&&workspace.store(e,d.__props.alias);0<--l&&!f;)"undefined"!=typeof n[l].__instance&&(f=n[l].__instance);f?f.setState(f.state,function(){t.succeeded&&t.succeeded()}):t.succeeded&&t.succeeded(e)},z=function(e){BLE.connect(e).then(function(){return BLE.retrieveServices(e)}).then(function(b){var a=k.match(/^ble?:\/\/.+\/services\/(.+)\/characteristics\/(.+)/i)||[];if(a[1]&&a[2]){if(/^post$/i.test(g.method)){b=[];for(var d=0;d<g.body.length;++d){var f=g.body.charCodeAt(d);b=b.concat([f])}BLE.writeWithoutResponse(e,a[1],a[2],b).then(function(){w()})["catch"](function(b){console.log(b.message)})}}else w(b)})["catch"](function(b){console.log(b.message)})},x=function(){var a=((k.match(/^ble?:\/\/(.+)/i)||[])[1]||"").split("/").filter(function(b){return b}).shift();a?z(a):(u.addListener("BleManagerDiscoverPeripheral",function(b){b=b||{};"undefined"!=typeof b.name&&(v[b.id]=b)}),u.addListener("BleManagerStopScan",function(){var b=[],a;for(a in v)b.push(v[a]);w(b)}),BLE.scan([],5,!0))};global.ble?x():BLE.start({showAlert:!1}).then(function(){global.ble={};u.addListener("BleManagerDisconnectPeripheral",function(a){console.log("device: ",a,"disconnected")});x()})
        /* local */
        } else if(/^dev?:\/\//i.test(k)) {
            /* contact */
            /* info */
        /* http */
        } else {
            fetch(k,g).then(function(a){
                var b=null,e=t[a.ok?"succeeded":"failed"];try{b=JSON.parse(a._bodyInit)}catch(B){b=null}b||(b={content:a._bodyInit});for(workspace.store(b,d.__props.alias);0<--l&&!f;)"undefined"!=typeof n[l].__instance&&(f=n[l].__instance);f?f.setState(f.state,function(){e&&e()}):e&&e(b)
            });
        }
    }
};