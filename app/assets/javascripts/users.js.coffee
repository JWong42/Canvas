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
        console.log(link)
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
          console.log('success')
          console.log(data.count)
          canvas = $(@).closest('div.canvas')
          $(canvas).hide()
          if data.count is 0 
            $('div.canvases').prepend('<p class="notice">There are no existing canvases owned by you.  Create one now to get started.</p>')
    'a.delete'
