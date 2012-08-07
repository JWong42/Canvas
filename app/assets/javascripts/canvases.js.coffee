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
                    <li style='color: #{data.color}' data-id=#{data.text}>#{content}</li>
                  </div>
                  <div class='item-options'>
                    <a href='#' rel='tooltip' title='Change label' class='switch-color'><i class='icon-tag'></i></a>
                    <a href='#' rel='tooltip' title='Delete item' class='remove-item'><i class='icon-remove'></i></a>
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
      console.log('for item content edit')
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
      baseLink = $(location).attr('href')
      canvasComponent = $(@).closest('td.area').attr('id')
      id = $(@).closest('div.item-container').find('li').attr('data-id')
      link = "#{baseLink}/#{canvasComponent}/#{id}"
      $.ajax 
        url: link 
        type: 'DELETE'
        success: (data) => 
          console.log(data.text)
          $(@).closest('.item-container').hide()
    'mouseenter': (e) -> 
      $(@).tooltip('show')
    'mouseleave': (e) -> 
      $(@).tooltip('hide')
    'a.remove-item'

  $('div.items').on 
    'click': (e) -> 
      e.stopPropagation()
      e.preventDefault()
      baseLink = $(location).attr('href')
      canvasComponent = $(@).closest('td.area').attr('id')
      id = $(@).closest('div.item-container').find('li').attr('data-id')
      link = "#{baseLink}/#{canvasComponent}/#{id}" 
      style = $(@).closest('.item-container').find('li').attr('style')
      re = style.match(/#[a-z0-9]+$/)
      color = re[0]     
      newColor = switch color 
        when '#3ba1bf' then '#61dc3f'
        when '#61dc3f' then '#ff0000'
        when '#ff0000' then '#3ba1bf'
      $.ajax 
        url: link 
        type: 'PUT'
        data: 
          style: newColor
        success: (data) => 
          $(@).closest('div.item-container').find('li').attr("style", "color: #{newColor}")
    'mouseenter': (e) -> 
      $(@).tooltip('show')
    'mouseleave': (e) -> 
      $(@).tooltip('hide')
    'a.switch-color'

