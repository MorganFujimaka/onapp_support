$ ->
  urefs = $('#urefs').text().split(', ')
  $('#q_search').autocomplete
    source: urefs
    minLength: 2
    autoFocus: true