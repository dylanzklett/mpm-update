#= require ./index

class App.Classes.TaskDialog
  constructor: (@link) ->
    @new_path = $(@link).data('newPath')
    @open_path = $(@link).data('openPath')
    $(@link).click @showDialog
  showDialog: =>
    $('body').append @buildBlocker()
    $('body').append @buildDialog()
  buildBlocker: ->
    $(document.createElement("div")).attr(
      class: 'task-dialog-blocker'
      style: 'position:fixed;
              top:0;
              bottom:0;
              left:0;
              right:0;
              z-index:1000;
              background: rgba(0, 0, 0, 0.4);'
    ).click @removeDialog
  buildDialog: =>
    $(document.createElement("div")).attr(
      class: 'task-dialog'
      style: 'position:fixed;
              top:30%;
              left:40%;
              z-index:1001;
              width: 300px;
              background: #f0f0f0;
              padding: 10px;
              text-align: center;'
    ).append(
      @buildClose()
    ).append(
      @buildMessage()
    ).append(
      @buildLink(@new_path, 'Create New')
    ).append(
      @buildLink(@open_path, 'Open exists one')
    )
  buildClose: =>
    $(document.createElement("span")).attr(
      style: 'float: right; font-weight:bold; cursor:pointer;'
    ).text('X').click @removeDialog
  removeDialog: ->
    $('.task-dialog, .task-dialog-blocker').remove()
  buildMessage: ->
    $(document.createElement("div")).text(
      'You already created a task for this type of manufacturer. Are you sure you want another, or would you rather edit the existing task?'
    )
  buildLink: (url, text) ->
    $(document.createElement("a")).attr(
      class: 'btn btn-warning'
      href:  url
      style: 'margin-right:10px;'
    ).text(text)

$(document).on "ready page:load", ->
  $('.show-task-dialog').each (index, link) ->
    new App.Classes.TaskDialog(link)
