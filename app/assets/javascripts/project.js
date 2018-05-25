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
      //result = $.parseJSON(result);
      alert(result['reason']);
    });
  }
}
