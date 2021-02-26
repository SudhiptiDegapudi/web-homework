defmodule Homework.Pagination do

  def find_page_no(page, total_results, limit) do
    total_pages = count_total_pages(total_results, limit)
    if page > total_pages, do: total_pages, else: page
  end

  def count_total_pages(total_results, limit) do
    total_pages = ceil(total_results / limit)
    if total_pages > 0, do: total_pages, else: 1
  end
end
