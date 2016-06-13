#= require ./index

jQuery(document).ready ->
  CKEDITOR.on 'instanceReady', (e) ->
    editable = e.editor.editable()
    editable.attachListener(editable, 'contextmenu', ((evt) ->
      if $(evt.data.getTarget().$).parents('table.curtains').length > 0
        evt.stop()
        evt.data.preventDefault()
    ), null, null, 0);

