var hideFlashes = function() {
  $('p.notice, p.warning, p.error').fadeOut(1500)
}

$.fn.zebra = function() {
  $(this).find('tr').removeClass('odd').
    end().find('tr:odd').addClass('odd')
}

$.fn.toCurrency = function() {
  $(this).text('$' + Math.abs($(this).text()).toFixed(2))
}

$.fn.writeTaskTotal = function(hours, rate) {
  $(this).html(hours * rate).toCurrency()
}

$.extend({
  estimate: {
    total: function(options) {
      var options = $.extend({
        reload: false
      }, options), total = 0
      
      if (options.reload) $.estimate.totalTasks()
      
      $('.tasks .estimate span').each(function() {
        total += Math.abs($(this).text().replace(/\$|\,/g, ''))
      })

      $('#total span').text(total).toCurrency()
    },
    totalTasks: function() {
      $('input.hours, input.rate').each(function() {
        var hours = $(this).parents('.task').find('input.hours').val(),
            rate  = $(this).parents('.task').find('input.rate').val().replace('$', '')
            span  = $(this).parents('.task').find('.estimate span')

        span.writeTaskTotal(hours, rate)
      })
    }
  }
})

$(document).ready(function() {
  setTimeout(hideFlashes, 25000)
  
  $(':input:visible:enabled:first').focus()
  
  $('a[rel*=facebox]').facebox()
  
  $('form a[rel*=reset]').click(function() {
    $(this).parents('form')[0].reset()
    return false
  })
  
  $('form a.rate').click(function() {
    $('input.rate').val($(this).text().replace('$', ''))
    $.estimate.total({reload: true})
    return false
  })
  
  $.estimate.totalTasks()
  $.estimate.total()
  $('input.hours, input.rate').bind('keyup', function() { $.estimate.total({reload: true}) })
  
  $('ul.estimates li').mouseover(function() {
    $(this).addClass('highlight').find('span.options').show()
  }).mouseout(function() {
    $(this).removeClass('highlight').find('span.options').hide()
  })
});