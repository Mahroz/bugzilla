window.onload = function(){
  document.getElementById("bug_issue_type").value = 0;
  document.getElementById("bug_issue_type").addEventListener("change", function() {
    if(document.getElementById("bug_issue_type").value == "0")
    {
      document.getElementById('bug_status').options[2].innerHTML = "Resolved";
    }
    else{
      document.getElementById('bug_status').options[2].innerHTML = "Completed";
    }
  });
};
