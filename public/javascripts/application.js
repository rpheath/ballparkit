var hideFlashes = function() {
  $('p.notice, p.warning, p.error').fadeOut(1500);
}

$.fn.zebra = function() {
  $(this).find('tr').removeClass('odd').
    end().find('tr:odd').addClass('odd')
}

$(document).ready(function() {
  setTimeout(hideFlashes, 25000);
  
  $(':input:visible:enabled:first').focus()
});