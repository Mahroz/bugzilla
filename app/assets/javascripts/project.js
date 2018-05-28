function addUserToProject(){
  var userId = parseInt(document.getElementById("userName").dataset.userid);
  var projectId = parseInt( (window.location.href.split('projects/')[1]).split('/manage')[0] );
  if(userId < 1 ){
    alert("Please select a customer first");
  }
  else if(projectId < 1)
  {
    window.location.reload();
  }
  else{
    document.getElementById("userName").dataset.userid = "0";
    document.getElementById("userName").value = "";

    $.ajax({
      method: "POST",
      url: "add-members",
      dataType : 'json',
      data: { projectId: projectId, userId: userId }
    })
    .done(function(result) {
      notify(result['reason']);
    });
  }
}

function removeMember(userid){
  userid = parseInt(userid);
  var projectId = parseInt( (window.location.href.split('projects/')[1]).split('/manage')[0] );
  if(userid < 1 ){
    window.location.reload();
  }
  else if(projectId < 1)
  {
    window.location.reload();
  }
  else{
    $.ajax({
      method: "POST",
      url: "remove-members",
      dataType : 'json',
      data: { projectId: projectId, userId: userid }
    })
    .done(function(result) {
      notify(result['reason']);
      if(result['code'] == true)
      {
        $("#project-user-"+userid).hide();
      }
    });
  }
}
