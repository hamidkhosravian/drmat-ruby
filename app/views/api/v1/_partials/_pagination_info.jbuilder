json.pagination do
  json.current_page list.current_page
  json.next_page list.next_page
  json.prev_page list.prev_page
  json.total_pages list.total_pages
  json.total_count list.total_count
end
