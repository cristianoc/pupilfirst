tagSelectFilter = ->
  # TODO: v4 of Select2 will replace maximumSelectionSize with maximumSelectionLength, so specifying both for the moment.
  # Remove maximumSelectionSize after confirming upgrade to Select2 > v4.
  $('#resources-index-tags').select2({ placeholder : 'Tagged with', maximumSelectionLength: 3, maximumSelectionSize: 3 })

$(document).on 'page:change', ->
  if $('#resources-index-tags').length
    tagSelectFilter()