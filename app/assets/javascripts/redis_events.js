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
    $('ul#notifications').prepend('<div class="notification" data-type="new"><li>' + data.notification + '</li><li class="datetime">less than a minute ago</li></div><hr />'); 
     
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

      case 'item-create': 
        // make sure the user is on the right canvas id in the url
        $('td#' + data.component + ' div.items ul').append("<div class='item-container'><div class='item'><li style='color: " + data.item_color + "' data-id=" + data.item_id + ">" + data.item_content + "</li></div><div class='item-options'><a href='#' rel='tooltip' title='Change label' class='switch-color'><i class='icon-tag'></i></a><a href='#' rel='tooltip' title='Delete item' class='remove-item'><i class='icon-remove'></i></a></div></div>");
        //$(@).closest('td.area').on 'click', insertInput   // dont know if this one is actually needed? test without it 
        break; 
    
      case 'item-update': 
        console.log('ok item-update'); 
        $("td#" + data.component + " li[data-id='" + data.item_id + "']").attr("style", "color: " + data.item_color); 
        break; 
        
      case 'item-delete': 
        //$(@).closest('.item-container').hide()
        $("td#" + data.component + " li[data-id='" + data.item_id + "']").closest('div.item-container').hide(); 
        console.log('item delete works.');
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
          $(notification).css('background-color', '#eef7fa'); 
          $(notification).attr('data-type', ''); 
        } else {
          $(notification).css('background-color', 'none'); 
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
