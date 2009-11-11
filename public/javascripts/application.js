// when the DOM loads...
$(document).ready(function() {
  setTimeout("$('p.notice, p.warning, p.error').fadeOut(1500)", 8000)
  
  // go to the first textbox on the page
  $(':input:visible:enabled:first').focus()
  
  // activate facebox links
  $('a[rel*=facebox]').facebox()
  
  // launch external links
  $('a[rel*=external]').click(function() {
    window.open($(this).attr('href'))
    return false
  })
  
  // activate form resetting
  $('form a[rel*=reset]').click(function() {
    $(this).parents('form')[0].reset()
    return false
  })
  
  // fill in default rate in appropriate fields
  $('form a.rate').click(function() {
    $('input.rate').val($(this).text().replace(/\$|\,/g, ''))
    $.estimate.total({reload: true})
    return false
  })
  
  // disable tasks when clear_all is chosen
  $('input.clear').click(function() {
    var tasks = $('ul#default_tasks .default_task input.text'),
        checked = this.checked
    
    tasks.each(function() { this.disabled = checked ? true : false })
  })
  
  // the estimate form
  $.estimate.totalTasks()
  $.estimate.total()
  $.estimate.bindListeners()
  
  // show options on hover
  $('ul.estimates li').
    mouseover(function() { 
      $(this).addClass('highlight').find('span.options').show() 
    }).
    mouseout(function() { 
      $(this).removeClass('highlight').find('span.options').hide() 
    })
  
  // tooltips for icons
  $('span.options a').tooltip({follow: true})
});