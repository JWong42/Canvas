# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($) -> 

  insertInput = (e) -> 
    e.preventDefault() 
    type = $(@).find('div.items').attr('id')
    $(@).find('div.items').append("
        <div class='item-insert'>
          <input type='text' autofocus='autofocus' class=#{type}></input>
          <a href='#' class='new-save'>Save</a>
          <a href='#' class='new-cancel'>Cancel</a>
        </div> 
      ")
    $(@).off 'click', insertInput

  $('td.area').on 'click', insertInput 

  $('div.items').delegate 'input', 
    'click': (e) -> 
      e.stopPropagation()
      e.preventDefault() 
      $(@).val('')

  $('td.area').delegate 'a.new-save', 
    'click': (e) -> 
      e.stopPropagation()
      e.preventDefault() 
      inputField = $(@).closest('.item-insert').find('input')
      content = $(inputField).val()
      canvasComponent = $(@).closest('td.area').attr('id')
      link = $(location).attr('href') + '/' + canvasComponent
      if content isnt '' 
        $.ajax 
          url: link 
          type: 'POST'
          data: 
            toSent: content
          success: (data) => 
            console.log(data.text)
            $(@).closest('.item-insert').hide()
            $(@).closest('div.items').append(" 
              <ul>
                <div class='item-container'>
                  <div class='item'>
                    <li>#{content}</li>
                  </div>
                  <div class='item-options'>
                    <i class='icon-tag'></i>
                    <i class='icon-remove'></i>
                  </div>
                </div>
              </ul>
            ")
            $('td.area').on 'click', insertInput
      else 
        $(inputField).effect('highlight')
        
  $('div.items').delegate 'a.new-cancel', 
    'click': (e) -> 
      e.stopPropagation()
      e.preventDefault() 
      $(@).closest('.item-insert').hide()
      $(@).closest('td.area').on 'click', insertInput
      #$('td.area').on 'click', insertInput
      

