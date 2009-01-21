var hideFlashes = function() {
  $('p.notice, p.warning, p.error').fadeOut(1500);
}

$(document).ready(function() {
  setTimeout(hideFlashes, 25000);
  
  $(':input:visible:enabled:first').focus()
});