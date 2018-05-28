function assignBug(bugId){
  var projectId = parseInt( (window.location.href.split('projects/')[1]).split('/manage')[0] );
  if(projectId < 1)
  {
    window.location.reload();
  }
  else{
    $.ajax({
      method: "POST",
      url: "assign-bug",
      dataType : 'json',
      data: { projectId: projectId, bugId: bugId }
    })
    .done(function(result) {
      notify(result['reason']);
    });
  }
}

function markBug(bugId){
  var projectId = parseInt( (window.location.href.split('projects/')[1]).split('/manage')[0] );
  if(projectId < 1)
  {
    window.location.reload();
  }
  else{
    $.ajax({
      method: "POST",
      url: "mark-bug",
      dataType : 'json',
      data: { projectId: projectId, bugId: bugId }
    })
    .done(function(result) {
      notify(result['reason']);
    });
  }
}
