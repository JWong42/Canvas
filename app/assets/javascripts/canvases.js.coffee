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

  $('div.items').on 
    'click': (e) -> 
      e.stopPropagation()
      e.preventDefault() 
      $(@).val('')
    'input'

  $('td.area').on 
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
                    <li data-id=#{data.text}>#{content}</li>
                  </div>
                  <div class='item-options'>
                    <i class='icon-tag'></i>
                    <a href='#' class='remove-item'><i class='icon-remove'></i></a>
                  </div>
                </div>
              </ul>
            ")
            $(@).closest('td.area').on 'click', insertInput
      else 
        $(inputField).effect('highlight')
    'a.new-save'
        
  $('div.items').on 
    'click': (e) -> 
      e.stopPropagation()
      e.preventDefault() 
      $(@).closest('.item-insert').hide()
      $(@).closest('td.area').on 'click', insertInput
    'a.new-cancel'
      
  $('div.items'). on 
    'click': (e) -> 
      e.stopPropagation()
      e.preventDefault()
      console.log('hi')
    'mouseenter': (e) ->   
      e.stopPropagation()
      e.preventDefault()
      $(@).find('.item-options').css('display', 'inline')
    'mouseleave': (e) -> 
      e.stopPropagation()
      e.preventDefault() 
      $(@).find('.item-options').css('display', 'none')
    '.item-container'

  #$('div.item').delegate 'li', 
    #'click': (e) -> 
      #e.stopPropagation()
      #e.preventDefault()
      #beforeValue = $(@).html()
      #console.log(beforeValue) 
      #$(@).html('<input type="text"></input>')
      #$(@).append('<a href="#" class="edit-save">Save</a><a href="#" class="edit-cancel">Cancel</a>')

  $('div.items').on  
    'click': (e) -> 
      e.stopPropagation()
      e.preventDefault()
      id = $(@).closest('div.item-container').find('li').attr('data-id')
      baseLink = $(location).attr('href')
      canvasComponent = $(@).closest('td.area').attr('id')
      link = "#{baseLink}/#{canvasComponent}/#{id}"
      $.ajax 
        url: link 
        type: 'DELETE'
        success: (data) => 
          console.log(data.text)
          $(@).closest('.item-container').hide()
    '.remove-item'

