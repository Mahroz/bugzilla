function notify(message){
  $("#notifier").html(message);
  $("#notifier").slideDown().delay(3000).fadeOut();
}
