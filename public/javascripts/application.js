var hideFlashes = function() {
  $('p.notice, p.warning, p.error').fadeOut(1500);
}

$(document).ready(function() {
  setTimeout(hideFlashes, 25000);
  
  $(':input:visible:enabled:first').focus()
  
  function reloadZebra() {
    $('table.tasks tr').removeClass('odd');
    $('table.tasks tr:odd').addClass('odd');
  }
  
  $('table.tasks a.delete').click(function() {
    $(this).parent().parent().remove();
    reloadZebra();
    return false;
  });
  
  $('a.new').click(function() {
    var table = $('table.tasks'),
        row = $('table.tasks tr:last').clone(true);
    
    $(row).find('td input').each(function(i) {
      $(this).val('');
      $(this).attr('name', $(this).attr('name').replace(/\d+/, ''));
      $(this).attr('id', $(this).attr('id').replace(/\d+/, ''));
    });
    
    row.insertAfter('table.tasks tr:last');
    reloadZebra();
    return false;
  });
});