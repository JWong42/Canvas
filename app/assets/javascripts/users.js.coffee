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
              <div class='canvas' data-id='#{data.id}' data-name='#{data.name}'>
                <div class='canvas-info'>
                  <li class='edit'><a href='/users/#{user_id}/canvases/#{data.id}'>#{data.name}</a></li>
                  <p>Last updated - last than a minute ago</p> 
                </div> 
                <div class='canvas-options'>
                  <ul>
                    <li><i class='icon-edit'></i><a href='' class='edit'>Edit Name</a></li>
                    <li><i class='icon-remove'></i><a href='' class='delete'>Delete Canvas</a></li>
                    <li><i class='icon-group'></i><a href='#modalCollaborators' class='view'>View Collaborators</a></li>
                  </ul>
                </div> 
              </div>
            ")
            $('div.feeds').prepend("
              <div class='feed'>
                <p class='feed'>#{data.activity}</p>
                <p class='feed-time'>less than a minute ago</p>
              </div>
            ")
            $('#myModal').modal('hide')

  $('div.canvases').on 
    'click': (e) -> 
      e.preventDefault() 
      item = $(@).parents().find('li.edit')[0]
      $(item).html('<input type="text"></input>')
      $(item).append('<a href="" class="edit-save">Save</a><a href="" class="edit-cancel">Cancel</a>')
    'a.edit'

  $('div.canvases').on
    'click': (e) -> 
      e.preventDefault()
      content = $(@).closest('div.canvas').find('input').val()
      item = $(@).parents().find('li.edit')[0]
      if content != ''
        id = $(@).closest('div.canvas').attr('data-id')
        baseLink = $(location).attr('href')
        link = "#{baseLink}/canvases/#{id}"
        $.ajax  
          url: link 
          type: "PUT"
          data: 
            name: content 
          success: (data) => 
            $(@).closest('div.canvas').attr('data-name', data.name)
            $(item).html("<a href='#{link}'>#{data.name}</a>")
            $('div.feeds').prepend("
              <div class='feed'>
                <p class='feed'>#{data.activity}</p>
                <p class='feed-time'>less than a minute ago</p>
              </div>
            ")
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
          $('div.feeds').prepend("
            <div class='feed'>
              <p class='feed'>#{data.activity}</p>
              <p class='feed-time'>less than a minute ago</p>
            </div>
          ")
          if data.count is 0 
            $('div.canvases').prepend('<p class="notice">There are no existing canvases owned by you.  Create one now to get started.</p>')
    'a.delete'

  $('div.canvases').on 
    'click': (e) -> 
      e.preventDefault()
      id = $(@).closest('div.canvas').attr('data-id')
      $.cookie('canvas_id', id)
      $('div#invite-form').hide() 
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
      $('div#invite-form').toggle()
      console.log('a#invite-new clicked') 

  $('div#invite-form > input[type="submit"]').on 
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
          console.log('okay')
          console.log(data)
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

            $('div.feeds').prepend("
              <div class='feed'>
                <p class='feed'>#{data.invite.activity}</p>
                <p class='feed-time'>less than a minute ago</p>
              </div>
            ")

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

  $('div#invite-form > input').on 
    "focus": (e) -> 
      $(@).val('')

  $('div.content-area').on 
    'click': (e) -> 
      e.preventDefault() 
      $.ajax
        url: '/myinvites'
        type: 'GET'
        success: (data) => 
          console.log('success!')
          if data.invites_count is 1
              invitation = 'invitation'
          else
              invitation = 'invitations'
          $('div.modal-header h3').remove()
          $('div#modalInvites div.modal-header').append("
            <h3>Shared canvas #{invitation} (#{data.invites_count})</h3>
          ")
          $('div#invites').html('')
          for invite in data.invites
            $('div#invites').append("
            <div id='invite' data-id='#{invite.id}'>
              <i id='invite-icon' class='icon-th icon-2x'></i>
              <div id='invite-info'>
                <div id='invite-by'> 
                  <span data-canvas='#{invite.canvas_id}'>#{invite.canvas.name}, invited by #{invite.user.first_name} #{invite.user.last_name}</span> 
                </div> 
                <div id='invite-date'>#{invite.created_at}</div> 
              </div> 
              <div id='invite-confirm'> 
                <a id='accept' href='' class='new btn btn-info'>Accept</a>
                <a id='decline' href='' class='btn'>Decline</a>
              </div> 
            </div>
            ")
        error: (jqXHR, textStatus, errorThrown) =>  
          console.log(textStatus, errorThrown)
    'div#invites-show a'

  $('div#invites').on 
    'click': (e) -> 
      e.preventDefault()
      confirm_type = (@).id
      invite_id = $(@).closest('div#invite').attr('data-id')
      canvas_id = $(@).parent().prev().find('div#invite-by span').attr('data-canvas')
      canvas_name = $(@).parent().prev().find('div#invite-by span').text().split(',')[0]
      url = window.location.pathname 
      user_id = url.split("/")[-1..][0]
      $.ajax
        url: "/invites/#{invite_id}"
        type: 'PATCH' 
        data: 
          confirm: confirm_type
          canvas: canvas_id 
        success: (data) => 
          ## hide this invite and it shouldn't show up the next time either 
          $(@).closest('div#invite').hide()

          # if there is a no existing canvas notice, remove it 
          notice = $('div.canvases').find('p.notice')[0]
          $('p.notice').remove() if notice 

          # update the number of invites still need to be accepted or declined - the div invites-show part 
          # hide the modal invites link if the count reaches 0
          if data.count is 0
              $('div#invites-show').hide()
              $('div#modalInvites').modal('hide')
          else 
              $('div#invites-show > a').text("#{data.count} new shared canvas invitation")

          $('div.feeds').prepend("
            <div class='feed'>
              <p class='feed'>#{data.activity}</p>
              <p class='feed-time'>less than a minute ago</p>
            </div>
          ")

          ## Add the canvas with the newly created ownership - prepend it to the canvases div since its most recently updated
          if data.invite is 'accepted' 
            $('div.canvases').prepend("
              <div class='canvas' data-id='#{canvas_id}' data-name='#{canvas_name}'>
                <div class='canvas-info'>
                  <li class='edit'><a href='/users/#{user_id}/canvases/#{canvas_id}'>#{canvas_name}</a></li>
                   <p>Last updated - last than a minute ago</p>
                </div>
                <div class='canvas-options'>
                  <ul>
                    <li><i class='icon-edit'></i><a href='' class='edit'>Edit Name</a></li>
                    <li><i class='icon-remove'></i><a href='' class='delete'>Delete Canvas</a></li>
                    <li><i class='icon-group'></i><a href='#modalCollaborators' class='view'>View Collaborators</a></li>
                  </ul>
                </div>
              </div>
            ")
    'a'
