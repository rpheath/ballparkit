module ApplicationHelper
  def page_title(*args, &block)
    if block_given?
      concat(content_tag(:h1, capture(&block)))
    else
      content_tag(:h1, args.first)
    end
  end
end