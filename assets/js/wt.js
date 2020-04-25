"use strict";

var isConnected = false;
var hosturl;
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
      $("#hostlist").append('<li class="mdl-menu__item hostitem" onclick="setHost(this)">'+v+'</li>');
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
function setHost(){
  
}

///////////////////////////WEBSOCKET////////////
var websocket_client=null;

// connect to websocket
function ws_connect(hosturl){
  $("#progress").show();
  websocket_client = new WebSocket(hosturl);
  websocket_client.onopen = function(evt) { onOpen(evt) };
  websocket_client.onclose = function(evt) { onClose(evt) };
  websocket_client.onmessage = function(evt) { onMessage(evt) };
  websocket_client.onerror = function(evt) { onError(evt) };

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
  $("#cb").html('Connect <i class="material-icons">send</i>');
  $("#cb").removeClass('mdl-button--accent');
  $("#cb").addClass('mdl-button--primary');
  snackbar("Disconnected from "+hosturl);
    $("#conicon").removeClass('mdl-color-text--light-green-A700');
      $("#conicon").addClass('mdl-color-text--red-800');
}
function onMessage(evt){
  $("#msglog").prepend('<tr><td class="mdl-data-table__cell--non-numeric">'+evt.data+'</td></tr>');
console.log(evt);
}
function onError(evt){
console.log(evt);
}



/////////////////snackbar/////////////
function snackbar(txt){
  var snackbarContainer = document.querySelector('#snackbar');
  var data = {message: txt};
  snackbarContainer.MaterialSnackbar.showSnackbar(data);

}
