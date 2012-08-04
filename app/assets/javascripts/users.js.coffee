# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($) -> 

  $('#myModal').on 'show', -> 
    $('#myModal').css 
      width: '340px'
      'margin-top': -> 
        -($(this).height() / 2)
      'margin-left': ->
        -($(this).width() / 2) 
    $('input.new').val('My Canvas')

  $('input.new').on 
    "focus": (e) -> 
      $(@).val('')
    #"blur": -> 
      #$(@).val('My Canvas')

  $('a.save').on 
    'click': -> 
      $.ajax 
        url: "/canvases"
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
                <div class='canvas'>
                  <div class='canvas-info'>
                    <li class='edit'><a href='/canvases/#{data.id}'>#{data.name}</a></li>
                    <p>Last updated - last than a minute ago</p> 
                  </div> 
                  <div class='canvas-options'>
                    <ul>
                      <li><a href='#' class='edit'><i class='icon-edit'></i>Edit Name</a></li>
                      <li><a href='#' class='delete'><i class='icon-remove'></i>Delete Canvas</a></li>
                      <li><a href='#' ><i class='icon-plus'></i>Add Collaborators</a></li>
                    </ul>
                  </div> 
                </div>
              </ol> 
            ")
            $('#myModal').modal('hide')

  $('a.edit').live 
    'click': (e) -> 
      e.preventDefault() 
      item = $(@).parents().find('li.edit')[0]
      beforeValue = $(item).html()
      $(item).html('<input type="text"></input>')
      $(item).append('<a href="#" class="edit-save">Save</a><a href="#" class="edit-cancel">Cancel</a>')

      $('a.edit-save').click (e) ->
        e.preventDefault()
        content = $(item).find('input').val()
        if content != ''
          link = $(beforeValue).attr('href')
          $.ajax  
            url: link 
            type: "PUT"
            data: 
              name: content 
            success: (data) -> 
              $(item).html($(beforeValue).text(data.text))
        else 
          $(item).find('input').effect('highlight')
        
      $('a.edit-cancel').click (e) -> 
        e.preventDefault()
        $(item).html(beforeValue)

