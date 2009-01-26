var hideFlashes = function() {
  $('p.notice, p.warning, p.error').fadeOut(1500)
}

$.fn.zebra = function() {
  $(this).find('tr, li').removeClass('odd').
    end().find('tr:odd, li:odd').addClass('odd')
}

$(document).ready(function() {
  setTimeout(hideFlashes, 25000);
  
  $(':input:visible:enabled:first').focus()
  
  $('a[rel*=facebox]').facebox()
  
  $('form a[rel*=reset]').click(function() {
    $(this).parents('form')[0].reset()
    return false
  })
  
  $('ul.estimates li').mouseover(function() {
    $(this).addClass('highlight').find('span.options').show();
  }).mouseout(function() {
    $(this).removeClass('highlight').find('span.options').hide();
  })
});