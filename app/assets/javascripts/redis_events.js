// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready(function() { 

  var data,
      source = new EventSource('/events');

  source.addEventListener('feeds', function(e) { 
    console.log(e.data); 
    data = JSON.parse(e.data); 
    var count = $('span#notifications').text();
    if (count == '') { 
      count = 0; 
    } else { 
      count = parseInt(count);
    } 
    count += 1;
    $('span#notifications').text(count);
    $('ul#notifications').prepend('<div class="notification" data-type="new"><li>' + data.notification + '</li><li>less than a minute ago</li></div>'); 
     
    switch(data.type) { 
      case 'edit-name': 
        var canvas = $('div.canvases div[data-id="' + data.id + '"]'); 
        $(canvas).attr('data-name', data.name); 
        var a = $(canvas).find('li.edit a'); 
        $(a).text(data.name); 
        break; 

      case 'delete-canvas': 
        console.log('it works');
        var canvas = $('div.canvases div[data-id="' + data.id + '"]'); 
        $(canvas).hide(); 
        if (data.count == 0) {
          $('div.canvases').prepend('<p class="notice">There are no existing canvases owned by you.  Create one now to get started.</p>')
        }
        break; 

      case 'invite-sent':
        console.log('it works');
        link = window.location.pathname;
        user_id = link.split("/")[2]
        if (data.id == user_id) { 
          var invitation; 
          if (data.invites_count == 1) { 
            invitation = 'invitation';
          } else { 
            invitation = 'invitations'; 
          } 
          $('div.content-area').find('div#invites-show').remove();
          $('div.content-area').prepend("<div id='invites-show'><hr id='top' class='invite'><a data-toggle='modal' href='#modalInvites'>" + data.invites_count + " new shared canvas " + invitation + "</a><hr id='bottom' class='invite'></div>"); 
        } 
        break; 
    } 

  }); 

  $('li#notifications').on('click', function(e) {
    e.preventDefault(); 
    $('span#notifications').text(''); 
      var notifications = $('ul#notifications').find('div.notification');  
      for (var i = 0; i < notifications.length; i++) { 
        var notification = notifications[i]
        if ($(notification).attr('data-type') == 'new') { 
          $(notification).css('background', 'blue'); 
          $(notification).attr('data-type', ''); 
        } else {
          $(notification).css('background', 'none'); 
        } 
      } 
    link = window.location.pathname;
    user_id = link.split("/")[2]
    $.ajax({
      url: "/unreadfeeds", 
      type: "PATCH", 
      data: {
        id: user_id
      },
      success: function(data) { 
       console.log('Updated unread feeds.');  
      } 
    }); 
  }); 

}); 
