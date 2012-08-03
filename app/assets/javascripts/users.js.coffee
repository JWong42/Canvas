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

