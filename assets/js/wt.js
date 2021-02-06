"use strict";

var isConnected = false;
var hosturl;
var raw_data;
var isObj = false;
var obj;
// fetch host list
function fetch_host_list(){
  var list = localStorage.getItem("hostlist");
  if(list == null){
    list = ["wss://echo.websocket.org","ws://localhost:3000"]
  }
  return list;
}

//add to host list
function add_to_hosts(url){
  var host_list = fetch_host_list().split(","); // to array
  if(host_list.includes(url)){
    //its in list  move to front
      var index = host_list.indexOf(url);
      host_list.splice(index,1);
  }
  //add to list
  host_list.unshift(url);
  return localStorage.setItem("hostlist",host_list);
}

// remove from list
function remove_host(url){
  var index = host_list.indexOf(url);
  return host_list.splice(index,1);

}


function show_host_list(){

  $("#hostlist").html('');
  var hlc =1;
  var hostlist = fetch_host_list().split(",");
  $("#host").val(hostlist[0]);
  $.each(hostlist,function(k,v){
    if(hlc < 11){
      $("#hostlist").append('<li class="mdl-menu__item hostitem" data-url="'+v+'" onclick="setHost(this)">'+v+'</li>');
   }
   hlc++;
 });

}



document.addEventListener('DOMContentLoaded', function(){
      show_host_list();
      $("#progress").hide();
}, false);



$("#cb").click(function(){
  if(isConnected){
    //its connected ->disconnect
      ws_disconnect();
  }else{
    hosturl = $("#host").val();
    ws_connect(hosturl)
  }
})

//set host on selection
function setHost(elem){
  $("#host").val($( elem ).data("url"));
}

///////////////////////////WEBSOCKET////////////
var websocket_client=null;

// connect to websocket
function ws_connect(hosturl){
  $("#progress").show();
  $("#cb").html('Connecting.. <i class="material-icons">hourglass_empty</i>');
  var sec_protocol =$("#sec-websocket-protocol").val();
  websocket_client = new WebSocket(hosturl,sec_protocol);
  websocket_client.onopen = function(evt) { onOpen(evt) };
  websocket_client.onclose = function(evt) { onClose(evt) };
  websocket_client.onmessage = function(evt) { onMessage(evt) };
  websocket_client.onerror = function(evt) { onError(evt) };
  $( "#host" ).prop( "disabled", true );
  $( "#accbtn").hide(100);
}
//disconnect from websocket
function ws_disconnect(){
  websocket_client.close();

}
//event functions
function onOpen(evt){
  // connected
  isConnected = true;
  // change the button
  $("#progress").hide(100);
  $("#cb").html('Disconnect <i class="material-icons">clear</i>');
  $("#cb").removeClass('mdl-button--primary')
  $("#cb").addClass('mdl-button--accent')
  snackbar("Connected to "+hosturl);
  add_to_hosts(hosturl);
  $("#conicon").addClass('mdl-color-text--light-green-A700');
}

function onClose(evt){
  isConnected = false;
  $( "#host" ).prop( "disabled", false );
  $("#cb").html('Connect <i class="material-icons">send</i>');
  $("#cb").removeClass('mdl-button--accent');
  $("#cb").addClass('mdl-button--primary');
  snackbar("Disconnected from "+hosturl);
  $("#conicon").removeClass('mdl-color-text--light-green-A700');
  $("#conicon").addClass('mdl-color-text--red-800');
  $( "#accbtn").show(100);
}
function onMessage(evt){
  $("#msglog").append('<tr><td class="mdl-data-table__cell--non-numeric text-green">RECV:'+evt.data+'</td></tr>');
console.log(evt);
}
$("#clear_msg").click(function(){
  $("#msglog").html('');
})

$("#data").keyup(function() {
  // get data
  raw_data = $("#data").val();

  try{
     obj = JSON.parse(raw_data);
     isObj = true;
  }catch(e){
    //console.log(e);
    isObj = false;
  }
  if(isObj){
      $("#isobj").addClass('mdl-color-text--light-green-A400');
  }else{
    $("#isobj").removeClass('mdl-color-text--light-green-A400');
  }
});


$("#emit").click(function(){
  if(isConnected){
    raw_data = $("#data").val();
    // send as json ?

    if(raw_data != null || raw_data != ""){
      var buf =null;
      if($('#objswitch').is(":checked")){
        console.log('send as obj');
        // send as obj set
        if(isObj){
          buf=obj;
          obj=null;
        }else{
          buf = String(raw_data);
        }
      }else{
        // send as string
        console.log('send as STRING');
        buf = String(raw_data);
      }
        websocket_client.send(buf);
      $("#data").val(''); // empty the data area
      $("#msglog").append('<tr><td class="mdl-data-table__cell--non-numeric text-blue">SENT:'+raw_data+'</td></tr>');

    }

  }else {
    snackbar("Please connect to websocket First!");
  }
})

function onError(evt){
$("#msglog").prepend('<tr><td class="mdl-data-table__cell--non-numeric">ERROR->'+evt.data+'</td></tr>');

}



/////////////////snackbar/////////////
function snackbar(txt){
  var snackbarContainer = document.querySelector('#snackbar');
  var data = {message: txt};
  snackbarContainer.MaterialSnackbar.showSnackbar(data);

}

const shell = require('electron').shell;

// assuming $ is jQuery
$(document).on('click', 'a[href^="http"]', function(event) {
    event.preventDefault();
    shell.openExternal(this.href);
});
