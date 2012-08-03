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
    console.log('hello')
    $('input.new').val('My Canvas')

  $('input.new').on 
    "focus": (e) -> 
      console.log('hi')
      $(@).val('')
    #"blur": -> 
      #$(@).val('My Canvas')

  $('a.save').on 
    'click': -> 
      console.log('hey')
      $('#myModal').modal('hide')
      $.ajax 
        url: "/canvases"
        type: "POST"
        data: 
          canvas: 
            name: $("input.new").val() 
        success: (data) -> 
          console.log(data.name)
          $('div.canvases p.notice').hide()
          $('div.canvases').prepend("
            <ol> 
              <div class='canvas'>
                <div class='canvas-info'>
                  <li><a href='#'>#{data.name}</a></li>
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
