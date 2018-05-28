var initial_time;
var check_time;
var setInverval_Variable = null;
// Setting autocomplete off
document.getElementById("userName").setAttribute( "autocomplete", "off" );
function showHint() {
    var date = new Date();
    initial_time = date.getTime();
    if (setInverval_Variable == null) {
            setInverval_Variable = setInterval(DelayedSubmission_Check, 50);
    }
}
function DelayedSubmission_Check() {
    var date = new Date();
    check_time = date.getTime();
    var limit_ms = check_time - initial_time;
    if (limit_ms > 500) { //Change value in milliseconds
        if(document.getElementById("userName").value.length > 2){
          var request;
          if(!request) request = new XMLHttpRequest();
            request.open("GET","/search-users/"+document.getElementById("userName").value , true);
            request.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
            request.onreadystatechange = function(){
              if (request.readyState == 4 && request.status == 200) {
                if(request.responseText != "") {
                  var d = $.parseJSON(request.responseText);
                  var userData = d["data"];

                  var hintString = "<ul id='hintSelect'>";
                  for(var i =0 ; i < userData.length ; i++){
                    var type = "developer";
                    var className = " btn-info ";
                    if(userData[i].user_type == 2){type = "qa"; className=" btn-success "}
                      hintString += "<li style='cursor:pointer' onclick='placeHint("+userData[i].id+" , "+'"'+userData[i].name+'"'+")'> <span class='searched-user-name'> "+userData[i].name+"</span><span class='btn btn-xs "+className+type+"'>"+type+"</span></li>";
                    }
                    hintString += "</ul>";
                    if(userData.length > 0){
                      document.getElementById("hint").innerHTML = hintString;
                    }
                  }
                }
            };
            request.send();
    }
      clearInterval(setInverval_Variable);
      setInverval_Variable  = null;
    }
}
function placeHint(id , name)
{
    document.getElementById("userName").value = name;
    document.getElementById("userName").dataset.userid = id;
    document.getElementById("hint").innerHTML= "";
}
function hideHint()
{
  document.getElementById("hint").innerHTML = "";
}
