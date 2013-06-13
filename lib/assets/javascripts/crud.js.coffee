$ ()->
  $('.crud .edit').click (e)->
    id = $(this).closest('tr').data('id')
    table_name = $(this).closest('table.crud').data('table-name')
    document.location = "/#{table_name}/#{id}/edit/"
    e.stopPropagation()

  $('.crud .delete').click (e)->
    if confirm('Are you sure you want to delete this?')
      $(this).closest('tr').fadeOut()
      id = $(this).closest('tr').data('id')
      table_name = $(this).closest('table.crud').data('table-name')
      $.ajax
        dataType: 'json'
        url: "/#{table_name}/#{id}"
        type: "DELETE"
    e.stopPropagation()
