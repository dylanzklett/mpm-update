#= require ./index

$(document).on 'focus', '.customer-autocomplete', ->
  $(@).autocomplete
    source: "/customers",
    dataType: 'JSON',
    minLength: 2,
    select: (event, ui) ->
      $('#project_customer_id').val ui.item.customer_id
      $('#sales_autocomplete').val ui.item.sales_data
      $('#project_sales_id').val ui.item.sales_id
$(document).on 'focus', '.sales-autocomplete', ->
  $(@).autocomplete
    source: "/sales",
    dataType: 'JSON',
    minLength: 2,
    select: (event, ui) ->
      $('#project_sales_id').val ui.item.sales_id
