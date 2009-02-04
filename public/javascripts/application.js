// fades flash messages
var hideFlashes = function() {
  $('p.notice, p.warning, p.error').fadeOut(1500)
}

// convenience way to check for characters
$.fn.contains = function(character) {
  this.toString().indexOf(character) > -1
}

// zebra stripes for tables
$.fn.zebra = function() {
  $(this).find('tr').removeClass('odd').
    end().find('tr:odd').addClass('odd')
}

// converts regular numbers to US dollar
$.fn.toCurrency = function() {
  var currency = Math.abs($(this).text()).toFixed(2),
      dollars  = currency.split('.')[0],
      cents    = currency.split('.')[1]
      
  for (var i = 0; i < Math.floor((dollars.length - (1 + i)) / 3); i++)
  	dollars = dollars.substring(0, dollars.length - (4 * i + 3)) + ',' + 
  	  dollars.substring(dollars.length - (4 * i + 3))
  
  $(this).text('$' + dollars + '.' + cents)
}

// calculates a task total for a given row
$.fn.writeTaskTotal = function(hours, rate) {
  var hours = Number(hours),
      rate  = Number(rate),
      price = isNaN(hours) || isNaN(rate) ? 0 : hours * rate
      
  $(this).html(price).toCurrency()
}

// estimate namespace
$.extend({
  estimate: {
    // totals the estimate form based on each
    // task total; to force task totals to be
    // reloaded, pass { reload: true }
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
    // totals a task for a given row
    totalTasks: function() {
      $('input.hours, input.rate').each(function() {
        var hours = $(this).parents('.task').find('input.hours').val(),
            rate  = $(this).parents('.task').find('input.rate').val(),
            span  = $(this).parents('.task').find('.estimate span')
        
        rate = rate ? rate.replace(/\$|\,/g, '') : rate
            
        span.writeTaskTotal(hours, rate)
      })
    },
    // any events related to live estimates
    bindListeners: function() {
      // bind the keyup to the estimate form so totals are live
      $('input.hours, input.rate').live('keyup', function() { $.estimate.total({reload: true}) })
    }
  }
})

// when the DOM loads...
$(document).ready(function() {
  setTimeout(hideFlashes, 25000)
  
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
    mouseover(function() { $(this).addClass('highlight') }).
    mouseout(function() { $(this).removeClass('highlight') })
});