// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready(function() { 
  var data,
      source = new EventSource('/events');
  source.addEventListener('feeds', function(e) { 
    console.log(e.data); 
    data = JSON.parse(e.data); 
    $('div.feeds').prepend('<p class="feed"><strong>User</strong> created a new canvas called - ' + '<a>' + data.name + '</a>' + '.</p><p class="feed-time">less than a minute ago</p>'); 
  }); 
}); 
