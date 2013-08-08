# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($) -> 

  $('#myModal').on 'show', -> 
    $('#myModal').css 
      width: '345px'
      'margin-top': -> 
        ($(this).height() / 2)
      'margin-left': ->
        -($(this).width() / 2) 
    $('input.new').val('My Canvas')

  $('input.new').on 
    "focus": (e) -> 
      $(@).val('')

  $('a.save').on 
    'click': (e) -> 
      e.preventDefault()
      link = $(location).attr('href')
      re = link.match(/[\d]+$/)
      user_id = re[0]
      $.ajax 
        url: "/users/#{user_id}/canvases"
        type: "POST"
        data: 
          canvas: 
            name: $("input.new").val() 
        success: (data) -> 
          if data.name is 'fail' 
            $('div.modal-body input').effect('highlight')
          else 
            $('div.canvases p.notice').hide()
            $('div.canvases').prepend("
              <ol> 
                <div class='canvas' data-id='#{data.id}' data-name='#{data.name}'>
                  <div class='canvas-info'>
                    <li class='edit'><a href='/users/#{user_id}/canvases/#{data.id}'>#{data.name}</a></li>
                    <p>Last updated - last than a minute ago</p> 
                  </div> 
                  <div class='canvas-options'>
                    <ul>
                      <li><i class='icon-edit'></i><a href='#' class='edit'>Edit Name</a></li>
                      <li><i class='icon-remove'></i><a href='#' class='delete'>Delete Canvas</a></li>
                      <li><i class='icon-plus'></i><a href='#' >Add Collaborators</a></li>
                    </ul>
                  </div> 
                </div>
              </ol> 
            ")
            $('#myModal').modal('hide')

  $('div.canvases').on 
    'click': (e) -> 
      e.preventDefault() 
      item = $(@).parents().find('li.edit')[0]
      $(item).html('<input type="text"></input>')
      $(item).append('<a href="#" class="edit-save">Save</a><a href="#" class="edit-cancel">Cancel</a>')
    'a.edit'

  $('div.canvases').on
    'click': (e) -> 
      e.preventDefault()
      content = $(@).closest('div.canvas').find('input').val()
      item = $(@).parents().find('li.edit')[0]
      console.log(item)
      if content != ''
        id = $(@).closest('div.canvas').attr('data-id')
        baseLink = $(location).attr('href')
        link = "#{baseLink}/canvases/#{id}"
        re = link.match(/[\d]+$/)
        user_id = re[0]
        $.ajax  
          url: link 
          type: "PUT"
          data: 
            name: content 
          success: (data) => 
            $(@).closest('div.canvas').attr('data-name', data.name)
            $(item).html("<a href='/users/#{user_id}/canvases/#{data.id}'>#{data.name}</a>")
      else 
        $(item).find('input').effect('highlight')
    'a.edit-save'
        
  $('div.canvases').on 
    'click': (e) -> 
      e.preventDefault()
      item = $(@).closest('li.edit')
      id = $(@).closest('div.canvas').attr('data-id')
      name = $(@).closest('div.canvas').attr('data-name')
      link = $(location).attr('href')
      re = link.match(/[\d]+$/)
      user_id = re[0]
      $(item).html("<a href='/users/#{user_id}/canvases/#{id}'>#{name}</a>")
    'a.edit-cancel'

  $('div.canvases').on 
    'click': (e) -> 
      e.preventDefault()
      id = $(@).closest('div.canvas').attr('data-id')
      baseLink = $(location).attr('href')
      link = "#{baseLink}/canvases/#{id}"
      $.ajax
        url: link
        type: "DELETE"
        success: (data) => 
          canvas = $(@).closest('div.canvas')
          $(canvas).hide()
          if data.count is 0 
            $('div.canvases').prepend('<p class="notice">There are no existing canvases owned by you.  Create one now to get started.</p>')
    'a.delete'

  $('div.canvases').on 
    'click': (e) -> 
      e.preventDefault()
      id = $(@).closest('div.canvas').attr('data-id')
      $.cookie('canvas_id', id)
      $('div#invite').hide() 
      $.ajax
        url: '/invites'
        type: 'GET'
        data: 
          canvas_id: id 
        success: (data) => 
          console.log(data.status)
          $('div#collaborators').html("")
          if data.invites
            for invite in data.invites 
              $('div#collaborators').append("
                <div id='collaborator' title=#{invite.email}>
                <i id='collaborator-icon' class='icon-user icon-large'></i>
                <div id='collaborator-name'>#{invite.name}</div>
                <div id='collaborator-status'>#{invite.status}</div>
                <a href='mailto:#{invite.email}' id='collaborator-mail'><i class='icon-envelope'></i></a>
                </div>
              ")

      $('#modalCollaborators').modal('show')
    'a.view'

  $('div#invite-new > a').on 
    'click': (e) -> 
      e.preventDefault()
      $('input#invite-name').val('Name')
      $('input#invite-email').val('Email')
      $('p#invite-error').text("") 
      $('div#invite').toggle()
      console.log('a#invite-new clicked') 

  $('div#invite > input[type="submit"]').on 
    'click': (e) -> 
      e.preventDefault()
      console.log('submit clicked.') 
      $.ajax 
        url: '/invites'
        type: 'POST'
        data: 
          invite: 
            canvas_id: $.cookie('canvas_id')
            name: $('input#invite-name').val()
            email: $('input#invite-email').val()
        success: (data) => 
          if data.status is 'error!' 
              errors = ''
              if data.invite.name 
                errors = errors + 'Name ' + data.invite.name[0] + '. '
              if data.invite.email 
                errors = errors + 'Email ' + data.invite.email[0] + '. '
              if errors
                console.log('errors: ' + errors)
                $('p#invite-error').text("* #{errors}")
          else 
              $('p#invite-error').text("") 
              $('div#collaborators').append("
                <div id='collaborator' title='#{data.invite.email}'>
                  <i id='collaborator-icon' class='icon-user icon-large'></i>
                  <div id='collaborator-name'>#{data.invite.name}</div>
                  <div id='collaborator-status'>#{data.invite.status}</div>
                  <a href='mailto:#{data.invite.email}'id='collaborator-mail'><i class='icon-envelope'></i></a>
                </div>
              ") 
              console.log(data.invite.name) 
              console.log(data.invite.email) 

  $('div#invite > input').on 
    "focus": (e) -> 
      $(@).val('')

