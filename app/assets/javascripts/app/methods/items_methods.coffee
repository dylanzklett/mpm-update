#= require ./index
App.Methods.Items = {}
App.Methods.TaskItems = {}

App.Methods.Items.remove_fields = (link) ->
  $(link).prev("input[type=hidden]").val(1)
  $(link).parents(".fields").first().hide()
  false
App.Methods.Items.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  $(link).before content.replace(regexp, new_id)
App.Methods.TaskItems.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  $(link).parents('tr').first().before content.replace(regexp, new_id)
